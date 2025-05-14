import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/module_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NetworkController networkController = Get.find();
  final StorageService storage = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CompanyRepository companyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final ModuleRepository moduleRepository = Get.find();
  var moduleReportsEnabled = false.obs;
  var user = UserModel().obs;
  var company = CompanyModel().obs;
  var refreshing = false.obs;

  @override
  void onInit() async {
    await _fetchUser();
    await _fetchEnabledModules();
    moduleReportsEnabled.value =
        storage.getEnabledModules().contains('reports');
    super.onInit();
  }

  @override
  void onReady() async {
    await _fetchCompany();
    var invoices = storage.getInvoiceList().length;
    if (invoices == 0) {
      await _loadInitialData();
    }
    _dataRefreshSchedule();
    super.onReady();
  }

  _loadInitialData() async {
    refreshing.value = true;
    DialogHelper.showLoading('Loading data');
    List<CustomerModel> customers = storage.getCustomerList();

    if (customers.isEmpty) {
      await _refreshCustomers()
          .then((customers) async => await _getUnpaidInvoices());
      DialogHelper.hideLoading();
      refreshing.value = false;
    } else {
      await _getModifiedCustomers()
          .then((customers) async => await _getModifiedInvoices());
      DialogHelper.hideLoading();
      refreshing.value = false;
    }
  }

  Future _dataRefreshSchedule() async {
    Timer.periodic(const Duration(minutes: 5), (Timer timer) async {
      if (networkController.connected.value) {
        refreshing.value = true;
        await _getModifiedCustomers();
        await _getModifiedInvoices();
        await _loadPaymentData();
      }

      refreshing.value = false;
    });
  }

  Future _refreshCustomers() async {
    final result = await customerRepository.fetchCustomerList();

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (customers) {
      for (CustomerModel customer in customers) {
        storage.storeCustomer(customer.id, customer);
        if (customer.address != null && customer.town != null) {
          storage.storeAddresses(
            '${customer.town}-${customer.address}',
            AddressModel(
              town: customer.town,
              address: customer.address,
            ),
          );
        }
      }
      DialogHelper.hideLoading();
    });
  }

  Future _loadPaymentData() async {
    List<InvoiceModel> invoices = storage.getInvoiceList();
    invoices.removeWhere(
        (i) => Utils.intAmounts(i.totalTtc) == Utils.intAmounts(i.sumpayed));

    List<InvoiceModel> payInvoices = <InvoiceModel>[];
    for (InvoiceModel invoice in invoices) {
      List<PaymentModel> list = storage.getPaymentList(invoiceId: invoice.id);
      List<int> amounts =
          list.map((payment) => Utils.intAmounts(payment.amount)).toList();
      int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);

      if (invoice.totalpaid > total) {
        payInvoices.add(invoice);
      }
    }

    for (InvoiceModel invoice in payInvoices) {
      final result = await invoiceRepository.fetchPaymentsByInvoice(
          invoiceId: invoice.id!);
      result.fold((failure) => null, (payments) {
        for (var payment in payments) {
          PaymentModel p = PaymentModel(
            amount: payment.amount,
            type: payment.type,
            date: payment.date,
            num: payment.num,
            fkBankLine: payment.fkBankLine,
            ref: payment.ref,
            invoiceId: invoice.id,
            refExt: payment.refExt,
          );
          storage.storePayment(payment.ref, p);
        }
      });
    }
  }

  Future _getModifiedCustomers() async {
    List<CustomerModel> list = storage.getCustomerList();
    list.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (list.isNotEmpty) {
      int dateModified = list[list.length - 1].dateModification;

      final result = await customerRepository.fetchCustomerList(
          dateModified: Utils.intToYMD(dateModified));

      result.fold((failure) => null, (customers) {
        for (CustomerModel customer in customers) {
          storage.storeCustomer(customer.id, customer);
          if (customer.address != null && customer.town != null) {
            storage.storeAddresses(
              '${customer.town}-${customer.address}',
              AddressModel(
                town: customer.town,
                address: customer.address,
              ),
            );
          }
        }
      });
    }
  }

  Future _getUnpaidInvoices() async {
    final result =
        await invoiceRepository.fetchInvoiceList(status: 'unpaid, draft');
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoices) {
      for (InvoiceModel invoice in invoices) {
        final customer = storage.getCustomer(invoice.socid);
        invoice.name = customer!.name;
        storage.storeInvoice(invoice.id!, invoice);
      }
    });
  }

  Future _getModifiedInvoices() async {
    List<InvoiceModel> invoices = storage.getInvoiceList();
    invoices.sort((a, b) => a.dateModification!.compareTo(b.dateModification!));
    if (invoices.isNotEmpty) {
      int? dateModified = invoices[invoices.length - 1].dateModification;
      final result = await invoiceRepository.fetchInvoiceList(
          dateModified: Utils.intToYMD(dateModified!));

      result.fold(
          (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
          (invoices) {
        for (InvoiceModel invoice in invoices) {
          final customer = storage.getCustomer(invoice.socid);
          invoice.name = customer!.name;
          storage.storeInvoice(invoice.id!, invoice);
        }
      });
    }
  }

  _fetchCompany() {
    if (storage.getCompany() == null) {
      _refreshCompanyData();
    } else {
      company.value = storage.getCompany()!;
    }
  }

  Future _refreshCompanyData() async {
    final result = await companyRepository.fetchCompany();
    result.fold((failure) {}, (entity) {
      storage.storeCompany(entity);
      company.value = entity;
    });
  }

  _fetchUser() async {
    if (storage.getUser() == null) {
      await _refreshUserData();
    } else {
      user.value = storage.getUser()!;
    }
  }

  Future<void> _refreshUserData() async {
    final result = await userRepository.login();
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (u) {
      storage.storeUser(u);
      user.value = u;
    });
  }

  fetchModified() async {
    refreshing.value = true;
    await _getModifiedCustomers();
    await _getModifiedInvoices();
    await _loadPaymentData();
    refreshing.value = false;
  }

  _fetchEnabledModules() async {
    final result = await moduleRepository.fetchEnabledModules();
    result.fold((failure) => storage.storeEnabledModules([]),
        (modules) => storage.storeEnabledModules(modules));
  }
}

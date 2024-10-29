import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NetworkController networkController = Get.find();
  final StorageController storage = Get.find();
  var user = UserModel().obs;
  var company = CompanyModel().obs;
  var refreshing = false.obs;

  @override
  void onInit() async {
    _fetchUser();

    _fetchCompany();

    super.onInit();
  }

  @override
  void onReady() {
    var invoices = storage.getInvoiceList().length;
    if (invoices == 0) {
      _loadInitialData();
    }
    _dataRefreshSchedule();
    super.onReady();
  }

  _loadInitialData() async {
    refreshing.value = true;
    DialogHelper.showLoading('Loading data');
    List<CustomerModel> customers = storage.getCustomerList();

    List<InvoiceModel> invoices = storage.getInvoiceList();

    if (customers.isEmpty) {
      await _refreshCustomers();
    } else {
      await _getModifiedCustomers();
    }

    if (invoices.isEmpty) {
      await _getUnpaidInvoices();
    } else {
      await _getModifiedInvoices();
    }

    DialogHelper.hideLoading();
    refreshing.value = false;
  }

  Future _dataRefreshSchedule() async {
    Timer.periodic(const Duration(minutes: 5), (Timer timer) async {
      if (networkController.connected.value) {
        refreshing.value = true;
        await _getModifiedCustomers().then((_) async {
          await _getModifiedInvoices().then((_) async {
            await _loadPaymentData().then((_) => refreshing.value = false);
          });
        });
      }
    });
  }

  Future _refreshCustomers() async {
    final result = await RemoteServices.fetchThirdPartyList();

    result.fold((failure) {
      DialogHelper.hideLoading();
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
    });
  }

  Future _loadPaymentData() async {
    List<InvoiceModel> invoices = storage.getInvoiceList();

    for (InvoiceModel invoice in invoices) {
      List<PaymentModel> list = storage.getPaymentList();
      List<int> amounts =
          list.map((payment) => Utils.intAmounts(payment.amount)).toList();
      int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);
      if (Utils.intAmounts(invoice.sumpayed) != total) {
        final result = await RemoteServices.fetchPaymentsByInvoice(invoice.id);
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
  }

  Future _getModifiedCustomers() async {
    List<CustomerModel> list = storage.getCustomerList();
    list.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (list.isNotEmpty) {
      int dateModified = list[list.length - 1].dateModification;

      final result = await RemoteServices.fetchThirdPartyList(
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
    final result = await RemoteServices.fetchInvoiceList(status: 'unpaid');
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (invoices) {
      for (InvoiceModel invoice in invoices) {
        storage.storeInvoice(invoice.id, invoice);
      }
    });
  }

  Future _getModifiedInvoices() async {
    List<InvoiceModel> invoices =
        storage.getInvoiceList().where((i) => i.remaintopay != "0").toList();
    invoices.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (invoices.isNotEmpty) {
      int dateModified = invoices[invoices.length - 1].dateModification;
      final result = await RemoteServices.fetchInvoiceList(
          dateModified: Utils.intToYMD(dateModified));

      result.fold(
          (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
          (invoices) {
        for (InvoiceModel invoice in invoices) {
          storage.storeInvoice(invoice.id, invoice);
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
    final result = await RemoteServices.fetchCompany();
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (c) {
      storage.storeCompany(c);
      company.value = c;
    });
  }

  void _fetchUser() {
    if (storage.getUser() == null) {
      _refreshUserData();
    } else {
      user.value = storage.getUser()!;
    }
  }

  Future<void> _refreshUserData() async {
    final result = await RemoteServices.login();
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (u) {
      storage.storeUser(u);
      user.value = u;
    });
  }
}

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:get/get.dart';

import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/utils.dart';

class HomeController extends GetxController {
  final NetworkController networkController = Get.find();
  final StorageController storageController = Get.find();
  RxString currentUser = ''.obs;
  RxString baseUrl = ''.obs;
  var refreshing = false.obs;
  Rx<CompanyModel> company = CompanyModel().obs;

  @override
  void onInit() async {
    currentUser.value = storageController.getSetting(StorageKey.user);
    baseUrl.value = storageController.getSetting(StorageKey.url);
    _fetchCompany();

    super.onInit();
  }

  @override
  void onReady() {
    var invoices = storageController.getInvoiceList().length;
    if (invoices == 0) {
      _loadInitialData().then((v) => _loadPaymentData());
    }
    _dataRefreshSchedule();
    super.onReady();
  }

  _loadInitialData() async {
    refreshing.value = true;
    DialogHelper.showLoading('Loading data');
    List<CustomerModel> customers = storageController.getCustomerList();

    List<InvoiceModel> invoices = storageController.getInvoiceList();

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
    await RemoteServices.fetchThirdPartyList().then((value) {
      if (value.statusCode == 200 && value.data != null) {
        List<CustomerModel> customers = value.data;
        for (CustomerModel customer in customers) {
          storageController.storeCustomer(customer.id, customer);
          if (customer.address != null && customer.town != null) {
            storageController.storeAdresses(
              '${customer.town}-${customer.address}',
              AddressModel(
                town: customer.town,
                address: customer.address,
              ),
            );
          }
        }
      }
    });
  }

  Future _loadPaymentData() async {
    List<InvoiceModel> invoices = storageController.getInvoiceList();

    for (InvoiceModel invoice in invoices) {
      List<PaymentModel> list = storageController.getPaymentList();
      List<int> amounts =
          list.map((payment) => Utils.intAmounts(payment.amount)).toList();
      int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);
      if (Utils.intAmounts(invoice.sumpayed) != total) {
        await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
          if (value.data != null) {
            final List<PaymentModel> payments = value.data;
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
              storageController.storePayment(payment.ref, p);
            }
          }
        });
      }
    }
  }

  Future _getModifiedCustomers() async {
    List<CustomerModel> list = storageController.getCustomerList();
    list.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (list.isNotEmpty) {
      int dateModified = list[list.length - 1].dateModification;

      await RemoteServices.fetchThirdPartyList(
              dateModified: Utils.intToYMD(dateModified))
          .then((value) {
        if (value.statusCode == 200 && value.data != null) {
          List<CustomerModel> customers = value.data;
          for (CustomerModel customer in customers) {
            storageController.storeCustomer(customer.id, customer);
            if (customer.address != null && customer.town != null) {
              storageController.storeAdresses(
                '${customer.town}-${customer.address}',
                AddressModel(
                  town: customer.town,
                  address: customer.address,
                ),
              );
            }
          }
        }
      });
    }
  }

  Future _getUnpaidInvoices() async {
    await RemoteServices.fetchInvoiceList(status: 'unpaid').then((value) {
      if (value.data != null) {
        final List<InvoiceModel> invoices = value.data;
        for (InvoiceModel invoice in invoices) {
          storageController.storeInvoice(invoice.id, invoice);
        }
      }
    });
  }

  Future _getModifiedInvoices() async {
    List<InvoiceModel> invoices = storageController
        .getInvoiceList()
        .where((i) => i.remaintopay != "0")
        .toList();
    invoices.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (invoices.isNotEmpty) {
      int dateModified = invoices[invoices.length - 1].dateModification;
      await RemoteServices.fetchInvoiceList(
              dateModified: Utils.intToYMD(dateModified))
          .then((value) {
        if (value.data != null) {
          final List<InvoiceModel> invoices = value.data;
          for (InvoiceModel invoice in invoices) {
            storageController.storeInvoice(invoice.id, invoice);
          }
        }
      });
    }
  }

  _fetchCompany() {
    if (storageController.getCompany() == null) {
      _refreshCompanyData();
    } else {
      company.value = storageController.getCompany()!;
    }
  }

  Future _refreshCompanyData() async {
    await RemoteServices.fetchCompany().then((value) {
      if (value.data != null) {
        final CompanyModel companyModel = value.data;
        storageController.storeCompany(companyModel);
      }
    });
  }
}

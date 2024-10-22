import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage_key.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final StorageController storageController = Get.find();
  RxString currentUser = ''.obs;
  RxString baseUrl = ''.obs;
  var refreshing = false.obs;

  @override
  void onInit() async {
    currentUser.value = storageController.getSetting(StorageKey.user);
    baseUrl.value = storageController.getSetting(StorageKey.url);
    _dataRefreshSchedule();
    super.onInit();
  }

  @override
  void onReady() {
    var invoices = storageController.getInvoiceList().length;
    if (invoices == 0) {
      _loadInitialData().then((v) => _loadPaymentData());
    }

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
      if (Get.find<NetworkController>().connected.value) {
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
          final List<PaymentModel> payments = value.data;
          if (value.data != null) {
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
}

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/utils.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class HomeController extends GetxController {
  RxString currentUser = ''.obs;
  RxString baseUrl = ''.obs;

  RxBool connected = false.obs;

  @override
  void onInit() async {
    connected.value = Storage.settings.get('connected');
    currentUser.value = Storage.settings.get('user');
    baseUrl.value = Storage.settings.get('url');
    Storage.settings.watch(key: 'connected').listen((event) {
      connected.value = event.value;
    });

    super.onInit();
  }

  @override
  void onReady() {
    if (connected.value) {
      _loadInitialData();
    }
    if (connected.value) {
      _invoicesRefreshSchedule();
    }
    if (connected.value) {
      _loadPaymentData();
    }

    super.onReady();
  }

  _loadInitialData() async {
    DialogHelper.showLoading('Loading initial data');
    List<CustomerModel> list = Storage.customers.values.toList();

    List<InvoiceModel> invoices = Storage.invoices.toMap().values.toList();

    if (list.isEmpty) {
      await _getAllCustomers();
    }
    if (invoices.isEmpty) {
      await _getUnpaidInvoices();
    }

    DialogHelper.hideLoading();
  }

  Future _loadPaymentData() async {
    List<InvoiceModel> invoices = Storage.invoices
        .toMap()
        .values
        .toList()
        .where((i) => i.remaintopay != "0")
        .toList();
    List<PaymentModel> payments =
        Storage.payments.toMap().values.toList().cast();

    if (payments.length < invoices.length) {
      for (InvoiceModel invoice in invoices) {
        if (invoice.remaintopay != "0") {
          await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
            if (!value.hasError) {
              Storage.payments.put(invoice.id, value.data);
            }
          });
        }
      }
    }
  }

  Future _invoicesRefreshSchedule() async {
    Timer.periodic(const Duration(minutes: 15), (Timer timer) async {
      if (connected.value) {
        await _getModifiedCustomers();

        await _getModifiedInvoices();
      }
    });
  }

  Future _getAllCustomers() async {
    await RemoteServices.fetchThirdPartyList().then((value) async {
      if (!value.hasError) {
        for (CustomerModel customer in value.data) {
          Storage.customers.put(customer.id, customer);
        }
      }
    });
  }

  Future _getModifiedCustomers() async {
    List<CustomerModel> list = Storage.customers.toMap().values.toList();
    list.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (list.isNotEmpty) {
      int dateModified = list[list.length - 1].dateModification;

      await RemoteServices.fetchThirdPartyList(
              dateModified: Utils.intToYearFirst(dateModified))
          .then((value) async {
        if (!value.hasError) {
          for (CustomerModel customer in value.data) {
            Storage.customers.put(customer.id, customer);
          }
        }
      });
    }
  }

  Future _getUnpaidInvoices() async {
    await RemoteServices.fetchInvoiceList(status: 'unpaid').then((value) async {
      if (!value.hasError) {
        for (InvoiceModel invoice in value.data) {
          Storage.invoices.put(invoice.id, invoice);
        }
      }
    });
  }

  Future _getModifiedInvoices() async {
    List<InvoiceModel> invoices = Storage.invoices
        .toMap()
        .values
        .toList()
        .where((i) => i.remaintopay != "0")
        .toList();
    invoices.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (invoices.isNotEmpty) {
      int dateModified = invoices[invoices.length - 1].dateModification;
      await RemoteServices.fetchInvoiceList(
              dateModified: Utils.intToYearFirst(dateModified))
          .then((value) async {
        if (!value.hasError) {
          for (InvoiceModel invoice in value.data) {
            Storage.invoices.put(invoice.id, invoice);
            await RemoteServices.fetchPaymentsByInvoice(invoice.id)
                .then((value) {
              if (!value.hasError) {
                Storage.payments.put(invoice.id, value.data);
              }
            });
          }
        }
      });
    }
  }

  logout() async {
    await clearStorage().then((logout) {
      Get.offAllNamed(Routes.SETTINGS);
    });
  }

  clearStorage() async {
    await Storage.settings.delete('apikey');
    await Storage.settings.delete('url');
    await Storage.settings.delete('user');
    await Storage.invoices.clear();
    await Storage.customers.clear();
    await Storage.payments.clear();
    await Storage.products.clear();
    await Storage.groups.clear();
  }
}

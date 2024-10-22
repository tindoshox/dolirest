import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString currentUser = ''.obs;
  RxString baseUrl = ''.obs;
  bool connected = Get.find<NetworkController>().connected.value;

  @override
  void onInit() async {
    currentUser.value = Storage.settings.get('user');
    baseUrl.value = Storage.settings.get('url');

    super.onInit();
  }

  @override
  void onReady() {
    var invoices = Storage.invoices.toMap().length;
    if (Get.find<NetworkController>().connected.value && invoices == 0) {
      _loadInitialData().then((v) => _loadPaymentData());
    }
    if (Get.find<NetworkController>().connected.value) {
      _dataRefreshSchedule();
    }

    super.onReady();
  }

  _loadInitialData() async {
    LoadingOverlay.showLoading('Loading data');
    List<CustomerModel> customers = Storage.customers.values.toList();

    List<InvoiceModel> invoices = Storage.invoices.toMap().values.toList();

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

    LoadingOverlay.hideLoading();
  }

  Future _dataRefreshSchedule() async {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) async {
      if (Get.find<NetworkController>().connected.value) {
        await _getModifiedCustomers();
        await _getModifiedInvoices();
        await _loadPaymentData();
      }
    });
  }

  Future _refreshCustomers() async {
    await RemoteServices.fetchThirdPartyList();
  }

  Future _loadPaymentData() async {
    List<InvoiceModel> invoices = Storage.invoices
        .toMap()
        .values
        .toList()
        .where((i) => i.remaintopay != "0")
        .toList();

    for (InvoiceModel invoice in invoices) {
      List<PaymentModel> list = Storage.payments
          .get(invoice.id, defaultValue: [])!.cast<PaymentModel>();
      List<int> amounts =
          list.map((payment) => Utils.intAmounts(payment.amount)).toList();
      int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);
      if (Utils.intAmounts(invoice.sumpayed) != total) {
        await RemoteServices.fetchPaymentsByInvoice(invoice.id);
      }
    }
  }

  Future _getModifiedCustomers() async {
    List<CustomerModel> list = Storage.customers.toMap().values.toList();
    list.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    if (list.isNotEmpty) {
      int dateModified = list[list.length - 1].dateModification;

      await RemoteServices.fetchThirdPartyList(
          dateModified: Utils.intToYMD(dateModified));
    }
  }

  Future _getUnpaidInvoices() async {
    await RemoteServices.fetchInvoiceList(status: 'unpaid');
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
          dateModified: Utils.intToYMD(dateModified));
    }
  }
}

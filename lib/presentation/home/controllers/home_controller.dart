import 'dart:async';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/utils.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';

class HomeController extends GetxController {
  RxString currentUser = ''.obs;
  RxString baseUrl = ''.obs;

  var connected = false.obs;

  @override
  void onInit() async {
    currentUser.value = Storage.settings.get('user');
    baseUrl.value = Storage.settings.get('url');
    Storage.settings.watch(key: 'connected').listen((event) {
      connected.value = event.value;
    });
    _connectivity();

    super.onInit();
  }

  @override
  void onReady() {
    var invoices = Storage.invoices.toMap().length;
    if (connected.value && invoices == 0) {
      _loadInitialData();
    }
    if (connected.value) {
      _dataRefreshSchedule();
    }
    if (connected.value) {
      _loadPaymentData();
    }

    super.onReady();
  }

  _loadInitialData() async {
    DialogHelper.showLoading('Loading data');
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

    DialogHelper.hideLoading();
  }

  Future _connectivity() async {
    Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      try {
        final result =
            await InternetAddress.lookup(Storage.settings.get('url'));
        connected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        connected.value = false;
      }
    });
  }

  Future _dataRefreshSchedule() async {
    Timer.periodic(const Duration(seconds: 30), (Timer timer) async {
      if (connected.value) {
        await _getModifiedCustomers();

        await _getModifiedInvoices();
      }
    });
  }

  Future _refreshCustomers() async {
    await RemoteServices.fetchThirdPartyList().then((value) async {
      if (!value.hasError) {
        for (CustomerModel customer in value.data) {
          Storage.customers.put(customer.id, customer);
        }
      }
    });
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

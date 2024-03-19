import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/utils.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeController extends GetxController {
  var currentUser = ''.obs;
  var baseUrl = ''.obs;

  RxBool connected = RxBool(getBox.read('connected'));

  @override
  void onInit() {
    currentUser.value = getBox.read('user');
    baseUrl.value = getBox.read('url');
    getBox.listenKey('connected', (value) async {
      connected.value = value;
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
    var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
    var list = box.toMap().values.toList();

    var invoiceBox = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    var invoices = invoiceBox.toMap().values.toList();

    if (list.isEmpty) {
      await _getAllCustomers();
    }
    if (invoices.isEmpty) {
      await _getAllInvoices();
    }

    DialogHelper.hideLoading();
  }

  Future _loadPaymentData() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    var paymentBox = await Hive.openBox<List>(BoxName.payments.name);
    var invoices =
        invoiceBox.toMap().values.toList().where((i) => i.remaintopay != "0");
    var payments = paymentBox.toMap().values.toList();

    if (payments.length < invoices.length) {
      for (var invoice in invoices) {
        await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
          if (!value.hasError) {
            paymentBox.put(invoice.id, value.data);
          }
        });
      }
    }
  }

  Future _invoicesRefreshSchedule() async {
    Timer.periodic(const Duration(minutes: 15), (Timer timer) async {
      if (getBox.read('connected')) {
        //await _getAllCustomers();
        //await _getAllInvoices();
        await _getModifiedCustomers();
        await _getModifiedInvoices();
      }
    });
  }

  Future _getAllCustomers() async {
    await RemoteServices.fetchThirdPartyList().then((value) async {
      if (!value.hasError) {
        var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
        for (ThirdPartyModel customer in value.data) {
          box.put(customer.id, customer);
        }
      }
    });
  }

  Future _getModifiedCustomers() async {
    var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
    var list = box.toMap().values.toList();
    list.sort((a, b) => a.dateModification.compareTo(b.dateModification));

    int dateModified = list[list.length - 1].dateModification;
    await RemoteServices.fetchThirdPartyList(
            dateModified: Utils.intToYearFirst(dateModified))
        .then((value) async {
      if (!value.hasError) {
        var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
        for (ThirdPartyModel customer in value.data) {
          box.put(customer.id, customer);
        }
      }
    });
  }

  Future _getAllInvoices() async {
    await RemoteServices.fetchInvoiceList().then((value) async {
      if (!value.hasError) {
        var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
        for (var invoice in value.data) {
          box.put(invoice.id, invoice);
        }
      }
    });
  }

  Future _getModifiedInvoices() async {
    var paymentBox = await Hive.openBox<List>(BoxName.payments.name);
    var invoiceBox = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    var invoices = invoiceBox
        .toMap()
        .values
        .toList()
        .where((i) => i.remaintopay != "0")
        .toList();
    invoices.sort((a, b) => a.dateModification.compareTo(b.dateModification));
    int dateModified = invoices[invoices.length - 1].dateModification;
    await RemoteServices.fetchInvoiceList(
            dateModified: Utils.intToYearFirst(dateModified))
        .then((value) async {
      if (!value.hasError) {
        for (var invoice in value.data) {
          invoiceBox.put(invoice.id, invoice);
          await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
            if (!value.hasError) {
              paymentBox.put(invoice.id, value.data);
            }
          });
        }
      }
    });
  }
}

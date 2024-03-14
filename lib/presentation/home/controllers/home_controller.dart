import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeController extends GetxController {
  var currentUser = DolibarrUserModel().obs;
  var baseUrl = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() async {
    baseUrl.value = getBox.read('url');
    bool connected = getBox.read('connected');
    if (connected) {
      await _fetchUserInfo();
      await _loadInitialData();
    }

    super.onInit();
  }

  @override
  void onReady() {
    bool connected = getBox.read('connected');
    if (connected) {
      _loadPaymentData();
      _startRefreshSchedule();
    }
    super.onReady();
  }

  _loadInitialData() async {
    DialogHelper.showLoading('Loading data. This may take up to 2 minutes');
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    var invoices = invoiceBox.toMap().values.toList();
    if (invoices.isEmpty) {
      _getAllInvoices();
    }
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    var list = box.toMap().values.toList();

    if (list.isEmpty) {
      await _getAllCustomers();
    }
    DialogHelper.hideLoading();
  }

  _loadPaymentData() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    var paymentBox = await Hive.openBox<List>('payments');
    var invoices = invoiceBox.toMap().values.toList();

    if (invoices.isNotEmpty) {
      for (var invoice in invoices) {
        await RemoteServices.fetchPaymentsByInvoice(invoice.id).then((value) {
          if (!value.hasError) {
            paymentBox.put(invoice.id, value.data);
          }
        });
      }
    }
  }

  Future _fetchUserInfo() async {
    isLoading.value = true;
    await RemoteServices.fetchUserInfo().then((value) {
      isLoading.value = false;
      if (!value.hasError) {
        currentUser(value.data);
        isLoading.value = false;
      }
    });
  }

  _startRefreshSchedule() async {
    Timer.periodic(const Duration(minutes: 5), (Timer timer) async {
      if (getBox.read('connected')) {
        await _getAllCustomers();
        await _getAllInvoices();
      }
    });
  }

  _getAllCustomers() async {
    await RemoteServices.fetchThirdPartyList().then((value) async {
      isLoading(false);
      if (!value.hasError) {
        var box = await Hive.openBox<ThirdPartyModel>('customers');
        for (ThirdPartyModel customer in value.data) {
          box.put(customer.id, customer);
        }
      }
    });
  }

  _getAllInvoices() async {
    await RemoteServices.fetchInvoiceList().then((value) async {
      isLoading(false);
      if (!value.hasError) {
        var box = await Hive.openBox<InvoiceModel>('invoices');
        for (var invoice in value.data) {
          box.put(invoice.id, invoice);
        }
      }
    });
  }
}

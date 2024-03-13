import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/build_document_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/document_list_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:open_filex/open_filex.dart';

class InvoiceDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> invoiceTabs =
      [const Tab(text: 'Details'), const Tab(text: 'Payments')].obs;
  var tabIndex = 0.obs;

  var customer = ThirdPartyModel().obs;
  var isLoading = false.obs;

  final invoiceId = Get.arguments['invoiceId'];
  final customerId = Get.arguments['customerId'];
  var selectedDate = DateTime.now().obs;
  var documentList = <DocumenListModel>[];

  late TabController tabController;
  late TargetPlatform? platform;
  late bool permissionReady;

  @override
  void onInit() async {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    tabController = TabController(length: invoiceTabs.length, vsync: this);

    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    await _fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  Future _fetchData() async {
    isLoading(true);
    // await _fetchInvoice();
    await _fetchPayments();

    await _fetchCustomer();

    isLoading(false);
  }

  Future _fetchPayments() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    var invoice = invoiceBox.get(invoiceId)!;
    var box = await Hive.openBox<List>('payments');
    var list = box.get(invoiceId, defaultValue: [])!.cast<PaymentModel>();

    var amounts = list.map((payment) => intAmounts(payment.amount)).toList();
    var total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);
    var sumpayed = intAmounts(invoice.sumpayed);

    // Fetch payment list from storage

    if (sumpayed != total) {
      // If storage has empty list but sumpayed is not null fetch from server
      await _refreshPaymentData();
    }
    //If Storage is valid
  }

  Future _refreshPaymentData() async {
    var box = await Hive.openBox<List>('payments');

    await (RemoteServices.fetchPaymentsByInvoice(invoiceId).then((value) {
      if (!value.hasError) {
        box.put(invoiceId, value.data);
      } else {
        SnackBarHelper.errorSnackbar(
            message:
                '${value.errorMessage}: Failed to refresh payment history');
      }
    }));
  }

  Future _fetchCustomer() async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    if (box.get(customerId) == null) {
      await _refreshCustomerData()
          .then((value) => customer.value = box.get(customerId)!);
    } else {
      customer.value = box.get(customerId)!;
    }
  }

  Future _refreshInvoiceData() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    await RemoteServices.fetchInvoiceById(invoiceId).then((value) {
      if (!value.hasError) {
        InvoiceModel newInvoice = value.data;
        invoiceBox.put(newInvoice.id, newInvoice);
      } else {
        Get.back();
        SnackBarHelper.errorSnackbar(
            message: '${value.errorMessage}: Failed to refresh Invoice data');
      }
    });
  }

  Future _refreshCustomerData() async {
    await RemoteServices.fetchThirdPartyById(customerId).then((value) async {
      var box = await Hive.openBox<ThirdPartyModel>('customers');
      if (!value.hasError) {
        box.put(customerId, value.data);
        customer.value = box.get(customerId)!;
      } else {
        Get.back();
        SnackBarHelper.errorSnackbar(
            message: '${value.errorMessage}: Failed to refresh customer data');
      }
    });
  }

  Future generateDocument() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    var invoice = invoiceBox.get(invoiceId)!;
    permissionReady = await checkPermission(platform);

    DialogHelper.showLoading('Downloading document...');
    var body = json.encode(BuildDocumentRequestModel(
      modulepart: 'invoice',
      originalFile: '${invoice.ref}/${invoice.ref}.pdf',
    ));

    if (permissionReady) {
      try {
        await RemoteServices.buildDocument(body).then((value) async {
          if (!value.hasError) {
            createFileFromString(value.data.content, '${invoice.ref}.pdf')
                .then((value) {
              OpenFilex.open(value);
            });
          } else {
            DialogHelper.hideLoading();
            SnackBarHelper.errorSnackbar(message: value.errorMessage);
          }
        });
      } catch (e) {
        Get.snackbar('Error', 'an unkown error occured');
      }
    } else {
      DialogHelper.hideLoading();
      Get.snackbar('Permission Error', 'Download Failed');
    }

    DialogHelper.hideLoading();
  }

  setDueDate() async {
    DateTime? newDueDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(DateTime.now().year + 1));

    if (newDueDate != null &&
        newDueDate != selectedDate.value &&
        newDueDate.isAfter(DateTime.now())) {
      selectedDate.value = newDueDate;
      _updateDueDate(dateTimeToInt(newDueDate));
    } else {
      Get.snackbar('Due Date', 'Not updated. New date must be in the future.',
          backgroundColor: Colors.grey[900],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future _updateDueDate(int selectedDate) async {
    DialogHelper.showLoading('Updating Due Date...');

    var update = InvoiceModel(dateLimReglement: selectedDate).toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    await RemoteServices.updateInvoice(invoiceId, body).then((value) {
      DialogHelper.hideLoading();
      if (!value.hasError) {
        _refreshInvoiceData();
        SnackBarHelper.successSnackbar(message: 'Due date changed');
      } else {
        SnackBarHelper.errorSnackbar(message: 'Update Failed');
      }
    });
  }
}

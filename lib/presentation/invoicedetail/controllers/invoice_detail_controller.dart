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

  var invoice = InvoiceModel().obs;
  var customer = ThirdPartyModel().obs;
  var isLoading = false.obs;

  final invoiceId = Get.arguments['invoiceId'];
  final customerId = Get.arguments['customerId'];
  bool refreshInvoice = Get.arguments['refresh'];
  var selectedDate = DateTime.now().obs;
  var documentList = <DocumenListModel>[];

  var payments = <PaymentModel>[].obs;

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

    await fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  Future fetchData() async {
    isLoading(true);

    await _fetchPayments(invoiceId);
    var customerBox = await Hive.openBox<ThirdPartyModel>('customers');
    customer.value = customerBox.get(customerId)!;

    if (refreshInvoice) {
      await refreshInvoiceData();
    } else {
      var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
      invoice.value = invoiceBox.get(invoiceId)!;
    }

    isLoading(false);
  }

  refreshInvoiceData() async {
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    await RemoteServices.fetchInvoiceById(invoiceId).then((value) {
      InvoiceModel newInvoice = value.data;
      invoiceBox.put(newInvoice.id, newInvoice);
      invoice.value = invoiceBox.get(newInvoice.id)!;
    });
  }

  Future generateDocument() async {
    permissionReady = await checkPermission(platform);

    DialogHelper.showLoading();
    var body = json.encode(BuildDocumentRequestModel(
      modulepart: 'invoice',
      originalFile: '${invoice.value.ref}/${invoice.value.ref}.pdf',
    ));

    if (permissionReady) {
      try {
        await RemoteServices.buildDocument(body).then((value) async {
          if (!value.hasError) {
            createFileFromString(value.data.content, '${invoice.value.ref}.pdf')
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

  Future _fetchPayments(String invoiceId) async {
    var box = await Hive.openBox<List<PaymentModel>>('payments');
    payments.value = box.get(invoiceId)!;
    // await (RemoteServices.fetchPaymentsByInvoice(invoiceId).then((value) {
    //   if (!value.hasError) {
    //     payments(value.data);
    //   }
    // }));
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
    DialogHelper.showLoading('Updating Due Date');

    var update = InvoiceModel(dateLimReglement: selectedDate).toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    await RemoteServices.updateInvoice(invoiceId, body).then((value) {
      DialogHelper.hideLoading();
      if (!value.hasError) {
        SnackBarHelper.successSnackbar(
            title: 'Due date changes', message: 'Reload invoice to rechanges');
      } else {
        Get.snackbar('Error', 'Update Failed');
      }
    });
  }
}

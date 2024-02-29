import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/build_document_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_by_id_model.dart';
import 'package:dolirest/infrastructure/dal/models/document_list_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_by_id_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_list_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:open_filex/open_filex.dart';

class InvoiceDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> invoiceTabs =
      [const Tab(text: 'Details'), const Tab(text: 'Payments')].obs;
  var tabIndex = 0.obs;

  var invoice = InvoiceById().obs;
  var customer = ThirdPartyById().obs;
  var isLoading = false.obs;

  final invoiceId = Get.arguments['invoiceId'];
  final customerId = Get.arguments['customerId'];
  var selectedDate = DateTime.now().obs;
  var documentList = <DocumenListModel>[];

  var payments = <Payment>[].obs;

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

    await _fetchInvoiceById(invoiceId);
    await _fetchCustomerById(customerId);
    await _fetchPayments(invoiceId);

    isLoading(false);
  }

  Future generateDocument() async {
    permissionReady = await checkPermission(platform);

    DialogHelper.showLoading();
    var body = json.encode(BuildDocumentRequestModel(
        modulepart: 'invoice',
        originalFile: '${invoice.value.ref}/${invoice.value.ref}.pdf',
        doctemplate: '',
        langcode: ''));

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
            Get.snackbar('Error', 'Download Failed');
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

  Future _fetchInvoiceById(String invoiceId) async {
    await RemoteServices.fetchInvoiceById(invoiceId).then((value) {
      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
        return;
      }
      if (!value.hasError) {
        invoice(value.data);
      }
    });
  }

  Future _fetchCustomerById(String customerId) async {
    await RemoteServices.fetchThirdPartyById(customerId).then((value) {
      if (!value.hasError) {
        customer(value.data);
      }
    });
  }

  Future _fetchPayments(String invoiceId) async {
    await (RemoteServices.fetchPaymentsByInvoice(invoiceId).then((value) {
      if (!value.hasError) {
        payments(value.data);
      }
    }));
  }

  setDueDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: intToDateTime(invoice.value.dateLimReglement),
        firstDate: intToDateTime(invoice.value.dateLimReglement),
        lastDate: DateTime(DateTime.now().year + 1));

    if (pickedDate != null &&
        pickedDate != selectedDate.value &&
        pickedDate.isAfter(DateTime.now())) {
      selectedDate.value = pickedDate;
      _updateDueDate(dateTimeToInt(pickedDate));
    } else {
      Get.snackbar('Due Date', 'Not updated. New date must be in the future.',
          backgroundColor: Colors.grey[900],
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future _updateDueDate(String selectedDate) async {
    DialogHelper.showLoading('Updating Due Date');

    var update = InvoiceById(dateLimReglement: selectedDate).toMap();
    update.removeWhere((key, value) => value == null || value == '');
    String body = jsonEncode(update);

    await RemoteServices.updateInvoice(invoiceId, body).then((value) {
      DialogHelper.hideLoading();
      if (!value.hasError) {
        invoice(value.data);
      } else {
        Get.snackbar('Error', 'Update Failed');
      }
    });
  }
}

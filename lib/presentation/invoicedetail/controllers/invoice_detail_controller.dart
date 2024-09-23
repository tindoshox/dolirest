import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
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

import 'package:open_filex/open_filex.dart';

class InvoiceDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final List<Tab> invoiceTabs = [
    const Tab(text: 'Details'),
    const Tab(text: 'Payments')
  ];
  RxInt tabIndex = 0.obs;

  Rx<CustomerModel> customer = CustomerModel().obs;
  RxBool isLoading = false.obs;

  String invoiceId = Get.arguments['invoiceId'];
  String customerId = Get.arguments['customerId'];
  Rx<DateTime> selectedDate = DateTime.now().obs;
  List<DocumentListModel> documentList = <DocumentListModel>[];
  TextEditingController refController = TextEditingController();

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
    await _fetchPayments();
    await _fetchCustomer();

    isLoading(false);
  }

  Future _fetchPayments() async {
    InvoiceModel invoice = Storage.invoices.get(invoiceId)!;
    List<PaymentModel> list =
        Storage.payments.get(invoiceId, defaultValue: [])!.cast<PaymentModel>();

    List<int> amounts =
        list.map((payment) => Utils.intAmounts(payment.amount)).toList();
    int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);
    int sumpayed = Utils.intAmounts(invoice.sumpayed);

    // Fetch payment list from storage

    if (sumpayed != total) {
      // If storage has empty list but sumpayed is not null fetch from server
      await _refreshPaymentData();
    }
  }

  Future _refreshPaymentData() async {
    await (RemoteServices.fetchPaymentsByInvoice(invoiceId));
  }

  _fetchCustomer() {
    if (Storage.customers.get(customerId) == null) {
      _refreshCustomerData()
          .then((value) => customer.value = Storage.customers.get(customerId)!);
    } else {
      customer.value = Storage.customers.get(customerId)!;
    }
  }

  Future _refreshInvoiceData() async {
    await RemoteServices.fetchInvoiceById(invoiceId);
  }

  Future _refreshCustomerData() async {
    await RemoteServices.fetchThirdPartyById(customerId);
  }

  Future generateDocument() async {
    InvoiceModel invoice = Storage.invoices.get(invoiceId)!;
    permissionReady = await Utils.checkPermission(platform);

    DialogHelper.showLoading('Downloading document...');
    String body = json.encode(BuildDocumentRequestModel(
      modulepart: 'invoice',
      originalFile: '${invoice.ref}/${invoice.ref}.pdf',
    ));

    if (permissionReady) {
      try {
        await RemoteServices.buildDocument(body).then((value) async {
          if (!value.hasError) {
            Utils.createFileFromString(value.data.content, '${invoice.ref}.pdf')
                .then((value) {
              OpenFilex.open(value);
            });
          } else {
            DialogHelper.hideLoading();
            SnackBarHelper.errorSnackbar(message: value.errorMessage);
          }
        });
      } catch (e) {
        Get.snackbar('Error', 'an unknown error occurred');
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
      _updateDueDate(Utils.dateTimeToInt(newDueDate));
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

import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_document_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/document_list_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class InvoiceDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageController storage = Get.find<StorageController>();
  final InvoiceRepository invoiceRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final DocumentRepository documentRepository = Get.find();
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
    InvoiceModel invoice = storage.getInvoice(invoiceId)!;
    List<PaymentModel> list = storage
        .getPaymentList()
        .where((p) => p.invoiceId == invoiceId)
        .toList();

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
    final result = await (invoiceRepository.fetchPaymentsByInvoice(invoiceId));

    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (payments) {
      for (var payment in payments) {
        PaymentModel p = PaymentModel(
          amount: payment.amount,
          type: payment.type,
          date: payment.date,
          num: payment.num,
          fkBankLine: payment.fkBankLine,
          ref: payment.ref,
          invoiceId: invoiceId,
          refExt: payment.refExt,
        );
        storage.storePayment(payment.ref, p);
      }
    });
  }

  _fetchCustomer() {
    if (storage.getCustomer(customerId) == null) {
      _refreshCustomerData()
          .then((value) => customer.value = storage.getCustomer(customerId)!);
    } else {
      customer.value = storage.getCustomer(customerId)!;
    }
  }

  Future _refreshInvoiceData() async {
    await invoiceRepository.fetchInvoiceList(customerId: customerId);
  }

  Future _refreshCustomerData() async {
    final result = await customerRepository.fetchCustomerById(customerId);
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (c) => storage.storeCustomer(c.id, c));
  }

  Future generateDocument() async {
    InvoiceModel invoice = storage.getInvoice(invoiceId)!;
    permissionReady = await Utils.checkPermission(platform);

    DialogHelper.showLoading('Downloading document...');
    String body = json.encode(BuildDocumentRequestModel(
      modulepart: 'invoice',
      originalFile: '${invoice.ref}/${invoice.ref}.pdf',
    ));

    if (permissionReady) {
      final result = await documentRepository.buildDocument(body);
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackbarHelper.errorSnackbar(message: failure.message);
      }, (document) {
        Utils.createFileFromString(document.content, '${invoice.ref}.pdf')
            .then((value) {
          DialogHelper.hideLoading();
          OpenFilex.open(value);
        });
      });
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

    final result = await invoiceRepository.updateInvoice(invoiceId, body);
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (invoice) {
      SnackbarHelper.successSnackbar(message: 'Due date changed');
      _refreshInvoiceData();
    });
  }
}

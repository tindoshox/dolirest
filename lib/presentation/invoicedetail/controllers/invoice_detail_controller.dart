import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_document_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/credit_available_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
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
  final StorageService storage = Get.find<StorageService>();
  final InvoiceRepository invoiceRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final DocumentRepository documentRepository = Get.find();
  final List<Tab> invoiceTabs = [
    const Tab(text: 'Details'),
    const Tab(text: 'Payments')
  ];
  RxInt tabIndex = 0.obs;

  Rx<CustomerModel> customer = CustomerModel().obs;
  Rx<InvoiceModel> document = InvoiceModel().obs;

  RxBool isLoading = false.obs;

  String documentId = Get.arguments['documentId'];
  String customerId = Get.arguments['customerId'];
  Rx<DateTime> selectedDate = DateTime.now().obs;
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
    await _fetchDocument();

    isLoading(false);
  }

  _fetchDocument() async {
    if (storage.getInvoice(documentId) == null) {
      _refreshInvoiceData()
          .then((value) => document.value = storage.getInvoice(documentId)!);
    } else {
      customer.value = storage.getCustomer(documentId)!;
    }
  }

  Future _fetchPayments() async {
    InvoiceModel invoice = storage.getInvoice(documentId)!;
    List<PaymentModel> list = storage
        .getPaymentList()
        .where((p) => p.invoiceId == documentId)
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
    final result =
        await (invoiceRepository.fetchPaymentsByInvoice(invoiceId: documentId));

    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (payments) {
      for (var payment in payments) {
        PaymentModel p = PaymentModel(
          amount: payment.amount,
          type: payment.type,
          date: payment.date,
          num: payment.num,
          fkBankLine: payment.fkBankLine,
          ref: payment.ref,
          invoiceId: documentId,
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
    final result =
        await invoiceRepository.fetchInvoiceList(customerId: customerId);
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoices) {
      for (InvoiceModel invoice in invoices) {
        final customer = storage.getCustomer(invoice.socid);
        invoice.name = customer!.name;
        storage.storeInvoice(invoice.id, invoice);
      }
    });
  }

  Future _refreshCustomerData() async {
    final result = await customerRepository.fetchCustomerById(customerId);
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (c) => storage.storeCustomer(c.id, c));
  }

  Future generateDocument() async {
    InvoiceModel invoice = storage.getInvoice(documentId)!;
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
        SnackBarHelper.errorSnackbar(message: failure.message);
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

  _updateDueDate(int selectedDate) async {
    DialogHelper.showLoading('Updating Due Date...');

    var update = InvoiceModel(dateLimReglement: selectedDate).toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    final result = await invoiceRepository.updateInvoice(
        invoiceId: documentId, body: body);
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoice) {
      DialogHelper.hideLoading();
      SnackBarHelper.successSnackbar(message: 'Due date changed');
      _refreshInvoiceData();
    });
  }

  validateDraft(invoiceId) async {
    DialogHelper.showLoading('Validating invoice...');
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result = await invoiceRepository.validateInvoice(
        body: body, documentId: invoiceId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Invoice validation failed');
    }, (v) async {
      await _refreshInvoiceData().then((value) {
        DialogHelper.hideLoading();

        SnackBarHelper.successSnackbar(message: 'Invoce validated');
      });
    });
  }

  void deleteDocument({required String invoiceId}) async {
    DialogHelper.showLoading('Deleting Invoice');
    final result = await invoiceRepository.deleteInvoice(documentId: invoiceId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Failed to delete draft');
    }, (deleted) {
      storage.deleteInvoice(invoiceId);

      DialogHelper.hideLoading();
      Get.back();
      SnackBarHelper.errorSnackbar(message: 'Invoice Deleted');
    });
  }

  creditNote({required bool productReturned}) async {
    DialogHelper.showLoading('Returning Item');
    var invoice = storage.getInvoice(documentId)!;

    /// Generate product line
    var ln = Line(
            qty: '1',
            subprice: invoice.remaintopay,
            fkProduct: productReturned ? invoice.lines![0].fkProduct : null,
            desc: productReturned
                ? invoice.lines![0].desc
                : 'Balance Written Off',
            description: productReturned
                ? invoice.lines![0].description
                : 'Balance Written Off',
            fkProductType:
                productReturned ? invoice.lines![0].fkProductType : null)
        .toJson();
    ln.removeWhere((key, value) => value == null);
    var lines = [ln];

    /// Generate main draft
    var credit = InvoiceModel(
        fkFactureSource: invoice.id,
        socid: invoice.socid,
        refClient: refController.text,
        type: '2',
        lines: []).toJson();

    credit.removeWhere((key, value) => value == null);
    credit['lines'] = lines;

    String body = jsonEncode(credit);

    final result = await invoiceRepository.createInvoice(body: body);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Create Draft: ${failure.message}');
    }, (id) async {
      await _validateDocument(documentId: id);
    });
  }

  ///
  /// Invoice validation
  /// Validate draft
  Future<void> _validateDocument({required String documentId}) async {
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result = await invoiceRepository.validateInvoice(
        body: body, documentId: documentId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Vaidate Credit Note: ${failure.message}');
    }, (v) async {
      await _markAsCreditAvailable(creditNoteId: documentId)
          .then((credit) async {
        await _fetchDiscount(credit: credit).then((discountId) async {
          await _applyDiscount(discountId: discountId).then(() async {
            await _classifyPaid();
          });
        });
      });
    });
  }

  _markAsCreditAvailable({required String creditNoteId}) async {
    final result = await invoiceRepository.markAsCreditAvailable(
        creditNoteId: creditNoteId);

    result.fold((failure) {
      log(failure.code.toString());
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Credit Available: ${failure.message}');
    }, (credit) {
      return credit;
    });
  }

  _fetchDiscount({required CreditAvailableModel credit}) async {
    final result =
        await invoiceRepository.fetchDiscount(creditNoteId: credit.id!);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Fetch Discount: ${failure.message}');
    }, (discount) {
      return discount.id;
    });
  }

  _applyDiscount({required String discountId}) async {
    final result = await invoiceRepository.useCreditNote(
        invoiceId: documentId, discountId: discountId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Apply Discount: ${failure.message}');
    }, (code) {
      return code;
    });
  }

  _classifyPaid() async {
    final result = await invoiceRepository.classifyPaid(invoiceId: documentId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Classify Paid: ${failure.message}');
    }, (code) async {
      await _refreshInvoiceData().then((r) {
        DialogHelper.hideLoading();
        Get.back();
        SnackBarHelper.successSnackbar(message: 'Successful');
      });
    });
  }

  closeCreditNote({required String creditNoteId}) {}
}

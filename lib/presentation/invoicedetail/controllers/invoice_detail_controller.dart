import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_document_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';

import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class InvoiceDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageService storage = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final DocumentRepository documentRepository = Get.find();
  final ProductRepository productRepository = Get.find();
  final List<Tab> invoiceTabs = [
    const Tab(text: 'Details'),
    const Tab(text: 'Payments')
  ];

  GlobalKey<FormState> addProductKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState> dropdownKey = GlobalKey<DropdownSearchState>();

  TextEditingController refController = TextEditingController();
  TextEditingController predefinedController = TextEditingController();
  TextEditingController freetextController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  var moduleProductEnabled = false.obs;

  var selectedProduct = ProductModel().obs;
  var productType = '1'.obs;

  var tabIndex = 0.obs;
  var customer = CustomerModel().obs;
  var document = InvoiceModel().obs;
  var payments = <PaymentModel>[].obs;

  RxBool isLoading = false.obs;

  String documentId = Get.arguments['documentId'];
  String customerId = Get.arguments['customerId'];
  Rx<DateTime> selectedDate = DateTime.now().obs;

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
    moduleProductEnabled.value =
        storage.getEnabledModules().contains('product');

    _watchBoxes();
    _updateCustomer();
    _updateDocument();
    _updatePayments();
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    super.onInit();
  }

  @override
  void onReady() {
    if (payments.isEmpty) {
      _loadPayments();
    }
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();

    refController.dispose();
    predefinedController.dispose();
    freetextController.dispose();
    priceController.dispose();
    customerController.dispose();
  }

  void _watchBoxes() {
    storage.customersListenable().addListener(_updateCustomer);
    storage.invoicesListenable().addListener(_updateDocument);
    storage.paymentsListenable().addListener(_updatePayments);
  }

  void _updateCustomer() {
    final c = storage.getCustomer(customerId);
    if (c != null) {
      customer.value = c;
    }
  }

  void _updateDocument() {
    final d = storage.getInvoice(documentId);
    if (d != null) {
      document.value = d;
    }
  }

  void _updatePayments() {
    payments.value = storage.getPaymentList(invoiceId: documentId);
  }

  _loadPayments() async {
    //Calculate total amount in payment list
    List<int> amounts =
        payments.map((payment) => Utils.intAmounts(payment.amount)).toList();
    int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);

    //Compare total to invoice outstanding and refresh if neccessary
    int sumpayed = Utils.intAmounts(document.value.sumpayed);

    if (sumpayed != total) {
      await _refreshPaymentData();
    }

    // payments.value = storage.getPaymentList(invoiceId: documentId);
  }

  Future _refreshPaymentData() async {
    isLoading.value = true;
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
    isLoading.value = false;
  }

  Future refreshInvoiceData() async {
    DialogHelper.showLoading('Refreshing Invoice');
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
    DialogHelper.hideLoading();
  }

  Future generatePDF() async {
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
      refreshInvoiceData();
    });
  }

  void deleteDocument({required String documentId}) async {
    DialogHelper.showLoading('Deleting Invoice');
    final result =
        await invoiceRepository.deleteInvoice(documentId: documentId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      if (failure.code == 404) {
        storage.deleteInvoice(documentId);
        Get.back();
        SnackBarHelper.errorSnackbar(message: 'Invoice Deleted');
      } else {
        SnackBarHelper.errorSnackbar(message: 'Failed to delete draft');
      }
    }, (deleted) {
      DialogHelper.hideLoading();
      storage.deleteInvoice(documentId);
      Get.back();
      SnackBarHelper.errorSnackbar(message: 'Invoice Deleted');
    });
  }

  creditNote({required bool productReturned}) async {
    DialogHelper.showLoading('Returning item');
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
      SnackBarHelper.errorSnackbar(message: 'create draft: ${failure.message}');
    }, (id) async {
      await validateDocument(id: id, invoiceValidation: false)
          .then((validatedId) async {
        await _markAsCreditAvailable(creditNoteId: validatedId)
            .then((availableId) async {
          await _fetchDiscount(creditNoteId: availableId)
              .then((discount) async {
            await _applyDiscount(
                    invoiceId: document.value.id, discountId: discount)
                .then((v) async {
              await _classifyPaid(invoiceId: document.value.id);
            });
          });
        });
      });
    });
  }

  ///
  /// Invoice validation
  /// Validate draft
  validateDocument(
      {required String id, required bool invoiceValidation}) async {
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result =
        await invoiceRepository.validateInvoice(body: body, docId: id);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Validation: ${failure.message}');
    }, (validated) async {
      if (invoiceValidation) {
        await refreshInvoiceData().then((value) {
          DialogHelper.hideLoading();

          SnackBarHelper.successSnackbar(message: 'Invioce validated');
        });
      }
    });
    return id;
  }

  _markAsCreditAvailable({required String creditNoteId}) async {
    final result = await invoiceRepository.markAsCreditAvailable(
        creditNoteId: creditNoteId);

    result.fold((failure) {
      log(failure.code.toString());
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Credit Available: ${failure.message}');
    }, (credit) {});
    return creditNoteId;
  }

  _fetchDiscount({required String creditNoteId}) async {
    String discountId = '';
    final result =
        await invoiceRepository.fetchDiscount(creditNoteId: creditNoteId);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Fetch Discount: ${failure.message}');
    }, (discount) {
      discountId = discount;
    });
    return discountId;
  }

  _applyDiscount(
      {required String invoiceId, required String discountId}) async {
    final result = await invoiceRepository.useCreditNote(
        invoiceId: invoiceId, discountId: discountId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Apply Discount: ${failure.message}');
    }, (code) {
      return code;
    });
  }

  _classifyPaid({required String invoiceId}) async {
    final result = await invoiceRepository.classifyPaid(invoiceId: documentId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Classify Paid: ${failure.message}');
    }, (code) async {
      await refreshInvoiceData().then((r) {
        DialogHelper.hideLoading();
        Get.back();
        SnackBarHelper.successSnackbar(message: 'Successful');
      });
    });
  }

  closeCreditNote() async {
    if (document.value.paye == PaidStatus.paid) {
      await _fetchDiscount(creditNoteId: document.value.id)
          .then((discountId) async {
        await _applyDiscount(
                invoiceId: document.value.fkFactureSource,
                discountId: discountId)
            .then((v) async {
          await _classifyPaid(invoiceId: document.value.fkFactureSource);
        });
      });
    } else {
      await _markAsCreditAvailable(creditNoteId: document.value.id)
          .then((v) async {
        await _fetchDiscount(creditNoteId: document.value.id)
            .then((discountId) async {
          await _applyDiscount(
                  invoiceId: document.value.id, discountId: discountId)
              .then((v) async {
            await _classifyPaid(invoiceId: document.value.fkFactureSource);
          });
        });
      });
    }
  }

  void setStockType(String value) {
    productType.value = value;
  }

  void clearProduct() {
    selectedProduct(ProductModel());
  }

  ///Product search for DropDown
  searchProduct({String searchString = ""}) {
    List<ProductModel> products = [];

    if (searchString == "") {
      products = storage.getProductList();
      products.sort((a, b) => a.label!.compareTo(b.label!));
    } else {
      products = storage
          .getProductList()
          .where((product) => product.ref!.contains(searchString))
          .toList();
      products.sort((a, b) => a.label!.compareTo(b.label!));
    }

    return products;
  }

  /// Validation
  Future<void> validateInputs() async {
    final FormState form = addProductKey.currentState!;
    if (form.validate()) {
      Get.back();
      DialogHelper.showLoading('Adding product...');
      // If stock type is free text.
      if (productType.value != '0') {
        await _addProduct();
      } else {
        /// if not free text: Check if product has stock above zero
        final result =
            await productRepository.checkStock(selectedProduct.value.id!);

        result.fold((failure) {
          DialogHelper.hideLoading();
          SnackBarHelper.errorSnackbar(message: 'Product has no stock');
        }, (stock) {
          _addProduct();
        });
      }
    }
    // DialogHelper.hideLoading();
  }

  Future<void> _addProduct() async {
    var line = Line(
            qty: '1',
            subprice: priceController.text,
            fkProduct: selectedProduct.value.id,
            desc: freetextController.text,
            description: freetextController.text,
            productType: productType.value,
            fkProductType:
                productType.value == '0' ? int.parse(productType.value) : null)
        .toJson();

    line.removeWhere((key, value) => value == null);

    String body = jsonEncode(line);

    final response =
        await invoiceRepository.addProduct(invoiceId: documentId, body: body);

    response.fold((failure) {
      Get.back();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (value) {
      Get.back();
      refreshInvoiceData();
    });
  }
}

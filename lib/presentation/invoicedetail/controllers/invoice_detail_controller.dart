import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dolirest/infrastructure/dal/models/build_document_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/models/product/product_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class InvoiceDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageService _storage = Get.find();
  final NetworkService _network = Get.find();
  final InvoiceRepository _invoiceRepository = Get.find();
  final DocumentRepository _documentRepository = Get.find();
  final DataRefreshService _data = Get.find();
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
  var connected = false.obs;
  var selectedProduct = ProductEntity().obs;
  var productType = '1'.obs;

  var tabIndex = 0.obs;
  var customer = CustomerEntity().obs;
  var document = InvoiceEntity().obs;
  var payments = <PaymentEntity>[].obs;

  RxBool isLoading = false.obs;

  Rx<DateTime> selectedDate = DateTime.now().obs;

  late TabController tabController;
  late TargetPlatform? _platform;
  late bool _permissionReady;

  @override
  void onInit() {
    everAll([
      _network.connected,
      payments,
      customer,
    ], (_) {
      connected = _network.connected;
    });
    connected = _network.connected;

    document.bindStream(_storage.invoiceBox
        .query(InvoiceEntity_.id.equals(Get.arguments['entityId']))
        .watch(triggerImmediately: true)
        .map((query) {
      return query.findUnique()!;
    }));

    document.value = _storage.invoiceBox.get(Get.arguments['entityId'])!;
    customer.value =
        _data.customers.firstWhere((c) => c.customerId == document.value.socid);

    payments.bindStream(_storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(document.value.documentId))
        .watch()
        .map((query) {
      return query.find();
    }));

    payments.value = _storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(document.value.documentId))
        .build()
        .find();

    if (Platform.isAndroid) {
      _platform = TargetPlatform.android;
    } else {
      _platform = TargetPlatform.iOS;
    }
    tabController = TabController(length: invoiceTabs.length, vsync: this);
    moduleProductEnabled.value = _storage.settingsBox
        .get(SettingId.moduleSettingId)!
        .listValue!
        .contains('product');

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

  Future<void> _loadPayments() async {
    List<int> amounts =
        payments.map((payment) => Utils.intAmounts(payment.amount)).toList();
    int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);

    if (document.value.totalpaid != total) {
      if (connected.value) {
        await _refreshPaymentData();
      } else {
        SnackBarHelper.errorSnackbar(message: 'Unable to load payments');
      }
    }

    payments.value = _storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(document.value.documentId))
        .build()
        .find();
  }

  Future _refreshPaymentData() async {
    isLoading.value = true;
    await _data.refreshPaymentData([document.value]);
    isLoading.value = false;
  }

  Future refreshInvoiceData(String invoiceId) async {
    DialogHelper.showLoading('Refreshing Invoice');
    final result = await _invoiceRepository.fetchInvoiceById(invoiceId);

    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoice) {
      _storage.storeInvoice(invoice);
    });
    DialogHelper.hideLoading();
  }

  Future generatePDF() async {
    _permissionReady = await Utils.checkPermission(_platform);

    DialogHelper.showLoading('Downloading document...');
    String body = json.encode(BuildDocumentRequestModel(
      modulepart: 'invoice',
      originalFile: '${document.value.ref}/${document.value.ref}.pdf',
    ));

    if (_permissionReady) {
      final result = await _documentRepository.buildDocument(body);
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: failure.message);
      }, (response) {
        Utils.createFileFromString(
                response.content, '${document.value.ref}.pdf')
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

  Future<void> setDueDate() async {
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

  Future<void> _updateDueDate(int selectedDate) async {
    DialogHelper.showLoading('Updating Due Date...');

    var update = InvoiceModel(dateLimReglement: selectedDate).toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    final result = await _invoiceRepository.updateInvoice(
        invoiceId: document.value.documentId, body: body);
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoice) async {
      await refreshInvoiceData(invoice.documentId);
      DialogHelper.hideLoading();
      SnackBarHelper.successSnackbar(message: 'Due date changed');
    });
  }

  Future<void> createCreditNote({required bool productReturned}) async {
    DialogHelper.showLoading('Returning item');

    DialogHelper.updateMessage('Preparing line item...');
    var ln = Line(
      qty: '1',
      subprice: document.value.remaintopay.toString(),
      fkProduct: productReturned ? document.value.lines[0].fkProduct : null,
      desc: productReturned
          ? document.value.lines[0].desc
          : 'Balance Written Off',
      description: productReturned
          ? document.value.lines[0].description
          : 'Balance Written Off',
      fkProductType:
          productReturned ? document.value.lines[0].fkProductType : null,
    ).toJson();
    ln.removeWhere((key, value) => value == null);
    var lines = [ln];

    DialogHelper.updateMessage('Creating draft credit note...');
    var credit = InvoiceModel(
      fkFactureSource: document.value.documentId,
      socid: document.value.socid,
      refCustomer: refController.text,
      type: '2',
      lines: ToMany(),
    ).toJson();

    credit.removeWhere((key, value) => value == null);
    credit['lines'] = lines;

    String body = jsonEncode(credit);

    final result = await _invoiceRepository.createInvoice(body: body);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'create draft: ${failure.message}');
    }, (creditNoted) async {
      DialogHelper.updateMessage('Validating credit note...');
      await validateDocument(id: creditNoted, invoiceValidation: false)
          .then((validatedId) async {
        DialogHelper.updateMessage('Marking credit available...');
        await _markAsCreditAvailable(creditNoteId: validatedId)
            .then((availableId) async {
          DialogHelper.updateMessage('Fetching discount...');
          await _fetchDiscount(creditNoteId: availableId)
              .then((discount) async {
            DialogHelper.updateMessage('Applying discount...');
            await _applyDiscount(
                    invoiceId: document.value.documentId, discountId: discount)
                .then((v) async {
              DialogHelper.updateMessage('Classifying as paid...');
              await _classifyPaid(invoiceId: document.value.documentId);
              DialogHelper.hideLoading();
            });
          });
        });
      });
    });
  }

  ///
  /// Invoice validation
  /// Validate draft
  Future<String> validateDocument(
      {required String id, required bool invoiceValidation}) async {
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result =
        await _invoiceRepository.validateInvoice(body: body, docId: id);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Validation: ${failure.message}');
      return;
    }, (validated) async {
      if (invoiceValidation == true) {
        await refreshInvoiceData(id).then((value) {
          DialogHelper.hideLoading();

          SnackBarHelper.successSnackbar(message: 'Invioce validated');
        });
      }
    });
    return id;
  }

  Future<String> _markAsCreditAvailable({required String creditNoteId}) async {
    final result = await _invoiceRepository.markAsCreditAvailable(
        creditNoteId: creditNoteId);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Credit Available: ${failure.message}');
      return;
    }, (credit) {});
    return creditNoteId;
  }

  Future<String> _fetchDiscount({required String creditNoteId}) async {
    String discountId = '';
    final result =
        await _invoiceRepository.fetchDiscount(creditNoteId: creditNoteId);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Fetch Discount: ${failure.message}');
      return;
    }, (discount) {
      discountId = discount;
    });
    return discountId;
  }

  Future<void> _applyDiscount(
      {required String invoiceId, required String discountId}) async {
    final result = await _invoiceRepository.useCreditNote(
        invoiceId: invoiceId, discountId: discountId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Apply Discount: ${failure.message}');
      return;
    }, (code) {
      return code;
    });
  }

  Future<void> _classifyPaid({required String invoiceId}) async {
    final result = await _invoiceRepository.classifyPaid(
        invoiceId: document.value.documentId);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Classify Paid: ${failure.message}');
      return;
    }, (code) async {
      await refreshInvoiceData(invoiceId).then((r) {
        DialogHelper.hideLoading();
        Get.back();
        SnackBarHelper.successSnackbar(message: 'Successful');
      });
    });
  }

  Future<void> closeCreditNote() async {
    if (document.value.paye == PaidStatus.paid) {
      await _fetchDiscount(creditNoteId: document.value.documentId)
          .then((discountId) async {
        await _applyDiscount(
                invoiceId: document.value.fkFactureSource!,
                discountId: discountId)
            .then((v) async {
          await _classifyPaid(invoiceId: document.value.fkFactureSource!);
        });
      });
    } else {
      await _markAsCreditAvailable(creditNoteId: document.value.documentId)
          .then((v) async {
        await _fetchDiscount(creditNoteId: document.value.documentId)
            .then((discountId) async {
          await _applyDiscount(
                  invoiceId: document.value.documentId, discountId: discountId)
              .then((v) async {
            await _classifyPaid(invoiceId: document.value.fkFactureSource!);
          });
        });
      });
    }
  }

  void setStockType(String value) {
    productType.value = value;
  }

  void clearProduct() {
    selectedProduct(ProductEntity());
  }

  ///Product search for DropDown
  List<ProductEntity> searchProduct({String searchString = ""}) {
    List<ProductEntity> products = [];

    if (searchString == "") {
      products = _storage.productBox.getAll();
      products.sort((a, b) => a.label!.compareTo(b.label!));
    } else {
      products = _storage.productBox
          .getAll()
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
        if (selectedProduct.value.stockReel == "0" ||
            selectedProduct.value.stockReel == null) {
          DialogHelper.hideLoading();
          SnackBarHelper.errorSnackbar(
            message: 'Product has no stock',
          );
          return;
        }
        _addProduct();
      }
    }
    // DialogHelper.hideLoading();
  }

  Future<void> _addProduct() async {
    var line = Line(
            qty: '1',
            subprice: priceController.text,
            fkProduct: selectedProduct.value.id.toString(),
            desc: freetextController.text,
            description: freetextController.text,
            productType: productType.value,
            fkProductType: productType.value == '0' ? productType.value : null)
        .toJson();

    line.removeWhere((key, value) => value == null);

    String body = jsonEncode(line);

    final response = await _invoiceRepository.addProduct(
        invoiceId: document.value.documentId, body: body);

    response.fold((failure) async {
      await refreshInvoiceData(document.value.documentId);
      Get.back();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (value) async {
      await refreshInvoiceData(document.value.documentId);
      Get.back();
    });
  }
}

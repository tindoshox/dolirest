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
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
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
  final StorageService storage = Get.find();
  final NetworkService network = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final DocumentRepository documentRepository = Get.find();
  final ProductRepository productRepository = Get.find();
  final DataRefreshService data = Get.find();
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

  // int entityId = Get.arguments['entityId'] ?? '';
  // String customerId = Get.arguments['customerId'] ?? '';
  Rx<DateTime> selectedDate = DateTime.now().obs;

  late TabController tabController;
  late TargetPlatform? platform;
  late bool permissionReady;

  @override
  void onInit() {
    everAll([
      network.connected,
      payments,
      customer,
    ], (_) {
      connected = network.connected;
    });
    connected = network.connected;

    document.bindStream(storage.invoiceBox
        .query(InvoiceEntity_.id.equals(Get.arguments['entityId']))
        .watch(triggerImmediately: true)
        .map((query) {
      return query.findUnique()!;
    }));

    document.value = storage.invoiceBox.get(Get.arguments['entityId'])!;
    customer.value =
        data.customers.firstWhere((c) => c.customerId == document.value.socid);

    payments.bindStream(storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(document.value.documentId))
        .watch()
        .map((query) {
      return query.find();
    }));

    payments.value = storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(document.value.documentId))
        .build()
        .find();

    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    tabController = TabController(length: invoiceTabs.length, vsync: this);
    moduleProductEnabled.value = storage.settingsBox
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

  _loadPayments() async {
    List<int> amounts =
        payments.map((payment) => Utils.intAmounts(payment.amount)).toList();
    int total = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b);

    if (document.value.totalpaid != total) {
      if (Get.find<NetworkService>().connected.value) {
        await _refreshPaymentData();
      } else {
        SnackBarHelper.errorSnackbar(message: 'Unable to load payments');
      }
    }

    payments.value = storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(document.value.documentId))
        .build()
        .find();
  }

  Future _refreshPaymentData() async {
    isLoading.value = true;
    await data.refreshPaymentData([document.value]);
    isLoading.value = false;
  }

  Future refreshInvoiceData(String invoiceId) async {
    DialogHelper.showLoading('Refreshing Invoice');
    final result = await invoiceRepository.fetchInvoiceById(invoiceId);

    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoice) {
      storage.storeInvoice(invoice);
    });
    DialogHelper.hideLoading();
  }

  Future generatePDF() async {
    permissionReady = await Utils.checkPermission(platform);

    DialogHelper.showLoading('Downloading document...');
    String body = json.encode(BuildDocumentRequestModel(
      modulepart: 'invoice',
      originalFile: '${document.value.ref}/${document.value.ref}.pdf',
    ));

    if (permissionReady) {
      final result = await documentRepository.buildDocument(body);
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
        invoiceId: document.value.documentId, body: body);
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoice) async {
      await refreshInvoiceData(invoice.documentId);
      DialogHelper.hideLoading();
      SnackBarHelper.successSnackbar(message: 'Due date changed');
    });
  }

  createCreditNote({required bool productReturned}) async {
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

    final result = await invoiceRepository.createInvoice(body: body);

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

  _markAsCreditAvailable({required String creditNoteId}) async {
    final result = await invoiceRepository.markAsCreditAvailable(
        creditNoteId: creditNoteId);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
          message: 'Credit Available: ${failure.message}');
      return;
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
      return;
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
      return;
    }, (code) {
      return code;
    });
  }

  _classifyPaid({required String invoiceId}) async {
    final result = await invoiceRepository.classifyPaid(
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

  closeCreditNote() async {
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
  searchProduct({String searchString = ""}) {
    List<ProductEntity> products = [];

    if (searchString == "") {
      products = storage.productBox.getAll();
      products.sort((a, b) => a.label!.compareTo(b.label!));
    } else {
      products = storage.productBox
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

  _addProduct() async {
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

    final response = await invoiceRepository.addProduct(
        invoiceId: document.value.documentId, body: body);

    response.fold((failure) {
      Get.back();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (value) async {
      await refreshInvoiceData(document.value.documentId);
      Get.back();
    });
  }
}

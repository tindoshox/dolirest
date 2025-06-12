import 'dart:async';
import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product/product_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart' show SettingId;
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateinvoiceController extends GetxController {
  final int? entityId = Get.arguments['entityId'];
  final StorageService storage = Get.find();
  final NetworkService network = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final ProductRepository productRepository = Get.find();
  var moduleProductEnabled = false.obs;
  var customer = CustomerEntity().obs;

  GlobalKey<FormState> createInvoiceKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState> dropdownKey = GlobalKey<DropdownSearchState>();

  TextEditingController invoiceDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController predefinedController = TextEditingController();
  TextEditingController freetextController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController customerController = TextEditingController();

  Rx<ProductEntity> selectedProduct = ProductEntity().obs;
  RxString productType = '1'.obs;
  var connected = false.obs;
  Rx<DateTime> invoiceDate = DateTime.now().obs;

  Rx<DateTime> dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  @override
  onInit() {
    ever(network.connected, (_) {
      connected = network.connected;
    });

    connected = network.connected;
    moduleProductEnabled.value = storage.settingsBox
        .get(SettingId.moduleSettingId)!
        .listValue!
        .contains('product');
    invoiceDateController.text = Utils.dateTimeToDMY(invoiceDate.value);
    dueDateController.text = Utils.dateTimeToDMY(dueDate.value);

    super.onInit();
  }

  @override
  void onReady() async {
    if (storage.productBox.getAll().isEmpty) {
      await _refreshProducts();
    }

    if (entityId != null) {
      fetchCustomerById(entityId!);
    }
    super.onReady();
  }

  @override
  void onClose() {
    invoiceDateController.dispose();
    dueDateController.dispose();
    refController.dispose();
    predefinedController.dispose();
    freetextController.dispose();
    priceController.dispose();
    customerController.dispose();
    super.onClose();
  }

  void setStockType(String value) {
    productType.value = value;
  }

  void clearCustomer() {
    customer(CustomerEntity());
  }

  _refreshProducts() async {
    final result = await productRepository.fetchProducts();
    result.fold((failure) {
      SnackBarHelper.errorSnackbar(message: 'Unable to load products');
    }, (products) {
      for (ProductEntity product in products) {
        storage.productBox.put(product);
      }
    });
  }

  ProductEntity upsertInvoice(ProductEntity product, Box<ProductEntity> box) {
    final existing = box
        .query(ProductEntity_.productId.equals(product.productId!))
        .build()
        .findFirst();

    if (existing != null) {
      product.id = existing.id;
    }

    box.put(product);
    return product;
  }

  fetchCustomerById(int customerId) {
    customer.value = storage.customerBox.get(customerId)!;
  }

  ///
  ///Set values for invoice date
  void setInvoiceDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: invoiceDate.value,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));

    invoiceDate.value = selectedDate!;
    invoiceDateController.text = Utils.dateTimeToDMY(selectedDate);
  }

  ///
  ///
  ///Set values Due date
  void setDueDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: dueDate.value,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));

    dueDate.value = selectedDate!;
    dueDateController.text = Utils.dateTimeToDMY(selectedDate);
  }

  /// Validation
  Future<void> validateInputs() async {
    final FormState form = createInvoiceKey.currentState!;
    if (form.validate()) {
      DialogHelper.showLoading('Validating inputs...');
      // If stock type is free text.
      if (productType.value != '0') {
        await _createInvoice();
      } else {
        /// if not free text: Check if product has stock above zero
        if (selectedProduct.value.stockReel == "0") {
          SnackBarHelper.errorSnackbar(
            message: 'Product has no stock',
          );
        } else {
          await _createInvoice();
        }
      }
    }
    // DialogHelper.hideLoading();
  }

  /// Attempt draft creation
  Future _createInvoice() async {
    DialogHelper.updateMessage('Creating darft ..');

    /// Generate product line

    var ln = Line(
            qty: '1',
            subprice: priceController.text,
            fkProduct: selectedProduct.value.id.toString(),
            desc: freetextController.text,
            description: freetextController.text,
            productType: productType.value,
            fkProductType: productType.value == '0' ? productType.value : null)
        .toJson();

    ln.removeWhere((key, value) => value == null);
    var lines = [ln];

    /// Generate main draft
    var invoice = InvoiceModel(
      socid: customer.value.customerId,
      date: Utils.dateTimeToInt(invoiceDate.value),
      refCustomer: refController.text,
      type: '0',
      dateLimReglement: Utils.dateTimeToInt(dueDate.value),
      condReglementCode: 'RECEP',
      modeReglementCode: 'LIQ',
    ).toJson();

    invoice.removeWhere((key, value) => value == null);
    invoice['lines'] = lines;

    String body = jsonEncode(invoice);

    // Submit for draft creation

    final result = await invoiceRepository.createInvoice(body: body);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
        message: failure.message,
      );
    }, (id) async {
      DialogHelper.updateMessage('Draft created ...');
      await _validateInvoice(id.toString());
    });
  }

  ///
  /// Invoice validation
  /// Happens if invoice creation is succesfull
  Future<void> _validateInvoice(String invoiceId) async {
    DialogHelper.updateMessage('Validating invoice ..');
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result =
        await invoiceRepository.validateInvoice(body: body, docId: invoiceId);
    result.fold((failure) {
      _getNewInvoice(invoiceId);
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'customerId': customer.value.id});
    }, (v) async {
      DialogHelper.updateMessage('Loading new invoice ...');
      await _getNewInvoice(invoiceId).then((id) {
        DialogHelper.hideLoading();

        Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {'entityId': id});
      });
    });
  }

//Update local data with new invoice
  Future<int> _getNewInvoice(String invoiceId) async {
    final result = await invoiceRepository.fetchInvoiceById(invoiceId);

    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (invoice) {
      storage.storeInvoice(invoice);
    });
    return storage.invoiceBox
        .query(InvoiceEntity_.documentId.equals(invoiceId))
        .build()
        .findFirst()!
        .id;
  }

  ///
  ///Customer search for DropDown
  searchCustomer({String searchString = ""}) {
    List<CustomerEntity> customers = [];

    if (searchString == "") {
      customers = storage.getCustomerList();
      customers.sort((a, b) => a.name.compareTo(b.name));
    } else {
      customers = storage
          .getCustomerList()
          .where((customer) =>
              customer.name.contains(searchString) ||
              customer.address.toString().contains(searchString) ||
              customer.town.toString().contains(searchString) ||
              customer.phone.toString().contains(searchString) ||
              customer.fax.toString().contains(searchString))
          .toList();
      customers.sort((a, b) => a.name.compareTo(b.name));
    }

    return customers;
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

  void clearProduct() {
    selectedProduct(ProductEntity());
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateinvoiceController extends GetxController {
  final String customerId = Get.arguments['customerId'] ?? '';
  final StorageService storage = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final ProductRepository productRepository = Get.find();
  var moduleProductEnabled = false.obs;
  var customer = CustomerModel().obs;

  GlobalKey<FormState> createInvoiceKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState> dropdownKey = GlobalKey<DropdownSearchState>();

  TextEditingController invoiceDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController predefinedController = TextEditingController();
  TextEditingController freetextController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController customerController = TextEditingController();

  Rx<ProductModel> selectedProduct = ProductModel().obs;
  RxString productType = '1'.obs;

  Rx<DateTime> invoiceDate = DateTime.now().obs;

  Rx<DateTime> dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  @override
  onInit() {
    moduleProductEnabled.value =
        storage.getEnabledModules().contains('product');
    invoiceDateController.text = Utils.dateTimeToString(invoiceDate.value);
    dueDateController.text = Utils.dateTimeToString(dueDate.value);
    _watchBoxes();
    _updateCustomer();
    super.onInit();
  }

  @override
  void onReady() async {
    if (storage.getProductList().isEmpty) {
      await _refreshProducts();
    }

    _fetchData();
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

  void _watchBoxes() {
    storage.customersListenable().addListener(_updateCustomer);
  }

  void _updateCustomer() {
    customer.value = storage.getCustomer(customerId) ?? CustomerModel();
  }

  void setStockType(String value) {
    productType.value = value;
  }

  void _fetchData() async {
    if (customerId.isEmpty) {
      await fetchCustomerById(customerId);
    }
  }

  void clearCustomer() {
    customer(CustomerModel());
  }

  _refreshProducts() async {
    final result = await productRepository.fetchProducts();
    result.fold((failure) {
      SnackBarHelper.errorSnackbar(message: 'Unable to load products');
    }, (products) {
      for (ProductModel product in products) {
        storage.storeProduct(product.id!, product);
      }
    });
  }

  fetchCustomerById(String customerId) {
    customer.value = storage.getCustomer(customerId) ?? CustomerModel();
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
    invoiceDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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
    dueDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
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
        DialogHelper.updateMessage('Checking stock..');

        /// if not free text: Check if product has stock above zero
        final result =
            await productRepository.checkStock(selectedProduct.value.id!);

        result.fold((failure) {
          DialogHelper.hideLoading();
          SnackBarHelper.errorSnackbar(message: 'Product has no stock');
        }, (stock) {
          _createInvoice();
        });
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
            fkProduct: selectedProduct.value.id,
            desc: freetextController.text,
            description: freetextController.text,
            productType: productType.value,
            fkProductType:
                productType.value == '0' ? int.parse(productType.value) : null)
        .toJson();

    ln.removeWhere((key, value) => value == null);
    var lines = [ln];

    /// Generate main draft
    var invoice = InvoiceModel(
        socid: customer.value.id,
        date: Utils.dateTimeToInt(invoiceDate.value),
        refClient: refController.text,
        type: '0',
        dateLimReglement: Utils.dateTimeToInt(dueDate.value),
        condReglementCode: 'RECEP',
        modeReglementCode: 'LIQ',
        lines: []).toJson();

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
      await _validateInvoice(id);
    });
  }

  ///
  /// Invoice validation
  /// Happens if invoice creation is succesfull
  Future<void> _validateInvoice(invoiceId) async {
    DialogHelper.updateMessage('Validating invoice ..');
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result =
        await invoiceRepository.validateInvoice(body: body, docId: invoiceId);
    result.fold((failure) {
      _deleteInvoice(invoiceId);
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'customerId': customer.value.id});
    }, (v) async {
      DialogHelper.updateMessage('Loading new invoice ...');
      await _getNewInvoice(invoiceId).then((value) {
        DialogHelper.hideLoading();

        Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {
          'documentId': invoiceId,
          'customerId': customer.value.id,
        });
      });
    });
  }

  void _deleteInvoice(String invoiceId) async {
    final result = await invoiceRepository.deleteInvoice(documentId: invoiceId);
    result.fold((failure) {}, (deleted) {
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'customerId': customer.value.id});
      SnackBarHelper.errorSnackbar(message: 'Could not create invoice');
    });
  }

//Update local data with new invoice
  Future _getNewInvoice(invoiceId) async {
    final result =
        await invoiceRepository.fetchInvoiceList(customerId: customer.value.id);

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

  ///
  ///Customer search for DropDown
  searchCustomer({String searchString = ""}) {
    List<CustomerModel> customers = [];

    if (searchString == "") {
      customers = storage.getCustomerList();
      customers.sort((a, b) => a.name!.compareTo(b.name!));
    } else {
      customers = storage
          .getCustomerList()
          .where((customer) =>
              customer.name!.contains(searchString) ||
              customer.address.toString().contains(searchString) ||
              customer.town.toString().contains(searchString) ||
              customer.phone.toString().contains(searchString) ||
              customer.fax.toString().contains(searchString))
          .toList();
      customers.sort((a, b) => a.name!.compareTo(b.name!));
    }

    return customers;
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

  void clearProduct() {
    selectedProduct(ProductModel());
  }
}

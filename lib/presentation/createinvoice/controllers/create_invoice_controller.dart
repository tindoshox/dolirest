import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/product_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateinvoiceController extends GetxController {
  final String invoiceId = '';
  final _customerId = Get.arguments['customerId'];
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();
  final ProductRepository products = Get.find();
  Rx<bool> moduleProductEnabled = false.obs;
  Rx<CustomerModel> customer = CustomerModel().obs;

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
  RxString stockType = '1'.obs;

  Rx<DateTime> invoiceDate = DateTime.now().obs;

  Rx<DateTime> dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  @override
  onInit() {
    moduleProductEnabled.value =
        storage.getEnabledModules().contains('product');
    invoiceDateController.text = Utils.dateTimeToString(invoiceDate.value);
    dueDateController.text = Utils.dateTimeToString(dueDate.value);

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

  void setStockType(String value) {
    stockType.value = value;
  }

  void _fetchData() async {
    if (_customerId != null) {
      await fetchCustomerById(_customerId);
    }
  }

  void clearCustomer() {
    customer(CustomerModel());
  }

  _refreshProducts() async {
    final result = await products.fetchProducts();
    result.fold((failure) {
      log(failure.message);
      SnackBarHelper.errorSnackbar(message: 'Unable to load products');
    }, (products) {
      for (ProductModel product in products) {
        storage.storeProduct(product.id!, product);
      }
    });
  }

  fetchCustomerById(String customerId) {
    customer.value = storage.getCustomer(customerId)!;
  }

  ///
  ///Set values for invoice date
  void setInvoiceDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: invoiceDate.value,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));

    invoiceDate.value = pickedDate!;
    invoiceDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
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
      DialogHelper.showLoading('Creating Invoice...');
      // If stock type is free text.
      if (stockType.value != '0') {
        await _createInvoice();
      } else {
        /// if not free text: Check if product has stock above zero
        final result = await products.checkStock(selectedProduct.value.id!);

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
    /// Generate product line

    var ln = Line(
            qty: '1',
            subprice: priceController.text,
            fkProduct: selectedProduct.value.id,
            desc: freetextController.text,
            description: freetextController.text,
            fkProductType:
                stockType.value == '0' ? int.parse(stockType.value) : null)
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

    final result = await repository.createInvoice(body: body);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(
        message: failure.message,
      );
    }, (id) async => await _validateInvoice(id));
  }

  ///
  /// Invoice validation
  /// Happens if invoice creation is succesfull
  Future<void> _validateInvoice(invoiceId) async {
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    final result =
        await repository.validateInvoice(body: body, documentId: invoiceId);
    result.fold((failure) {
      _deleteInvoice(invoiceId);
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'customerId': customer.value.id});
    }, (v) async {
      await _getNewInvoice(invoiceId).then((value) {
        DialogHelper.hideLoading();

        Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {
          'invoiceId': invoiceId,
          'customerId': customer.value.id,
        });
      });
    });
  }

  void _deleteInvoice(String invoiceId) async {
    final result = await repository.deleteInvoice(documentId: invoiceId);
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
        await repository.fetchInvoiceList(customerId: customer.value.id);

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
    debugPrint(products.toString());

    return products;
  }

  void clearProduct() {
    selectedProduct(ProductModel());
  }
}

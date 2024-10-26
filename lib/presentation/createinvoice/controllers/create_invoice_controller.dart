import 'dart:async';
import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';

import 'package:intl/intl.dart';

class CreateinvoiceController extends GetxController {
  final bool fromHomeScreen = Get.arguments['fromhome'];
  final _customerId = Get.arguments['customerId'];

  StorageController storageController = Get.find();
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
    invoiceDateController.text = Utils.dateTimeToString(invoiceDate.value);
    dueDateController.text = Utils.dateTimeToString(dueDate.value);

    super.onInit();
  }

  @override
  void onReady() async {
    List<ProductModel> list = storageController.getProductList();

    if (list.length < 50) {
      await refreshProducts();
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

  refreshProducts() async {
    await RemoteServices.fetchProducts().then((value) {
      if (value.data != null) {
        final List<ProductModel> products = value.data;
        for (ProductModel product in products) {
          storageController.storeProduct(product.id!, product);
        }
      }
    });
  }

  fetchCustomerById(String customerId) {
    customer.value = storageController.getCustomer(customerId)!;
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
        await RemoteServices.checkStock(selectedProduct.value.id!)
            .then((value) async {
          if (value.hasError) {
            DialogHelper.hideLoading();
            SnackbarHelper.errorSnackbar(message: 'Product has no stock');
          }
          await _createInvoice();
        });
      }
    }
    // DialogHelper.hideLoading();
  }

  /// Attempt draft creation
  Future _createInvoice() async {
    /// Generate product line
    Line line = Line(
        qty: '1',
        subprice: priceController.text,
        fkProduct: selectedProduct.value.id,
        desc: freetextController.text,
        description: freetextController.text,
        fkProductType:
            stockType.value == '0' ? int.parse(stockType.value) : null);

    /// Generate main draft
    var invoice = InvoiceModel(
        socid: customer.value.id,
        date: Utils.dateTimeToInt(invoiceDate.value),
        refClient: refController.text,
        type: '0',
        dateLimReglement: Utils.dateTimeToInt(dueDate.value),
        condReglementCode: 'RECEP',
        modeReglementCode: 'LIQ',
        lines: [line]).toJson();

    invoice.removeWhere((key, value) => value == null);

    String body = jsonEncode(invoice);

    /// Submit for draft creation

    await RemoteServices.createInvoice(body).then((value) async {
      if (value.hasError) {
        DialogHelper.hideLoading();
        SnackbarHelper.errorSnackbar(
          message: value.errorMessage,
        );
      } else {
        await _validateInvoice(value.data);
      }
    });
  }

  ///
  /// Invoice validation
  /// Happens if invoice creation is succesfull
  Future<void> _validateInvoice(invoiceId) async {
    String body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    await RemoteServices.validateInvoice(body, invoiceId).then((value) async {
      if (value.hasError) {
        debugPrint(value.statusCode.toString());
        await RemoteServices.deleteInvoice(invoiceId).then((v) {
          DialogHelper.hideLoading();
          Get.offAndToNamed(Routes.CREATEINVOICE);
          SnackbarHelper.errorSnackbar(message: 'Could not create invoice');
        });
      } else {
        await _getNewInvoice(invoiceId).then((value) {
          DialogHelper.hideLoading();

          Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {
            'invoiceId': invoiceId,
            'customerId': customer.value.id,
          });
        });
      }
    });
  }

//Update local data with new invoice
  Future _getNewInvoice(invoiceId) async {
    await RemoteServices.fetchInvoiceList(customerId: customer.value.id)
        .then((value) {
      if (value.data != null) {
        final List<InvoiceModel> invoices = value.data;
        for (InvoiceModel invoice in invoices) {
          storageController.storeInvoice(invoice.id, invoice);
        }
      }
    });
  }

  ///
  ///Customer search for DropDown
  searchCustomer({String searchString = ""}) {
    List<CustomerModel> customers = [];

    if (searchString == "") {
      customers = storageController.getCustomerList();
      customers.sort((a, b) => a.name.compareTo(b.name));
    } else {
      customers = storageController
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

  void clearProduct() {
    selectedProduct(ProductModel());
  }
}

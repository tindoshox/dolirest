import 'dart:async';
import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/product_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:intl/intl.dart';

class CreateinvoiceController extends GetxController {
  final bool fromHomeScreen = Get.arguments['fromhome'];
  final _customerId = Get.arguments['customerId'];

  var customer = ThirdPartyModel().obs;

  final createInvoiceKey = GlobalKey<FormState>();
  final dropdownKey = GlobalKey<DropdownSearchState>();

  final invoiceDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final refController = TextEditingController();
  final predefinedController = TextEditingController();
  final freetextController = TextEditingController();
  final priceController = TextEditingController();
  final customerController = TextEditingController();

  var selectedProduct = ProductModel().obs;
  var stockType = '1'.obs;

  var invoiceDate = DateTime.now().obs;

  var dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  @override
  onInit() {
    invoiceDateController.text = dateTimeToString(invoiceDate.value);
    dueDateController.text = dateTimeToString(dueDate.value);

    super.onInit();
  }

  @override
  void onReady() async {
    var box = await Hive.openBox<ProductModel>(BoxName.products.name);
    var list = box.toMap().values.toList();

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
    customer(ThirdPartyModel());
  }

  refreshProducts() async {
    var box = await Hive.openBox<ProductModel>(BoxName.products.name);
    await RemoteServices.fetchProducts().then((value) async {
      if (!value.hasError) {
        for (ProductModel product in value.data) {
          box.put(product.id, product);
        }
      }
    });
  }

  Future fetchCustomerById(String customerId) async {
    var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
    customer.value = box.get(customerId)!;
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
            SnackBarHelper.errorSnackbar(message: 'Product has no stock');
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
    var line = Line(
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
        date: dateTimeToInt(invoiceDate.value),
        refClient: refController.text,
        type: '0',
        dateLimReglement: dateTimeToInt(dueDate.value),
        condReglementCode: 'RECEP',
        modeReglementCode: 'LIQ',
        lines: [line]).toJson();

    invoice.removeWhere((key, value) => value == null);

    var body = jsonEncode(invoice);

    /// Submit for draft creation

    await RemoteServices.createInvoice(body).then((value) async {
      if (value.hasError) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(
          message: value.errorMessage,
        );
      }

      await _validateInvoice(value.data);
    });
  }

  ///
  /// Invoice validation
  /// Happens if invoice creation is succesfull
  Future<void> _validateInvoice(invoiceId) async {
    var body = '''{
      "idwarehouse": 1,
      "notrigger": 0
      }''';

    await RemoteServices.validateInvoice(body, invoiceId).then((value) async {
      if (value.hasError) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(
          message: value.errorMessage,
        );
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
    var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    await RemoteServices.fetchInvoiceById(invoiceId).then((value) {
      if (!value.hasError) {
        box.put(invoiceId, value.data);
      } else {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(
          message: value.errorMessage,
        );
      }
    });
  }

  ///
  ///Customer search for DropDown
  Future searchCustomer({String searchString = ""}) async {
    List<ThirdPartyModel> customers = [];

    var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);

    if (searchString == "") {
      customers = box.toMap().values.toList();
      customers.sort((a, b) => a.name.compareTo(b.name));
    } else {
      customers = box
          .toMap()
          .values
          .toList()
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
}

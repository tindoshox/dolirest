import 'dart:async';
import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/products_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';

import 'package:intl/intl.dart';

class CreateinvoiceController extends GetxController {
  final bool fromHomeScreen = Get.arguments['fromhome'];
  final _customerId = Get.arguments['customerId'];
  var customer = ThirdPartyModel().obs;

  final createInvoiceKey = GlobalKey<FormBuilderState>();

  final invoiceDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final refController = TextEditingController();
  final predefinedController = TextEditingController();
  final freetextController = TextEditingController();
  final priceController = TextEditingController();
  final customerController = TextEditingController();

  var selectedProduct = Product().obs;
  var stockType = 1.obs;

  var invoiceDate = DateTime.now().obs;

  var dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  @override
  onInit() {
    invoiceDateController.text = dateTimeToString(invoiceDate.value);
    dueDateController.text = dateTimeToString(dueDate.value);

    super.onInit();
  }

  @override
  void onReady() {
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

  void setStockType(int value) {
    stockType.value = value;
  }

  void _fetchData() async {
    if (_customerId != null) {
      await fetchCustomerById(_customerId);
    }
  }

  Future<List<Product>> fetchProducts(searchString) async {
    List<Product> products = [];

    var response = await RemoteServices.fetchProducts('%$searchString%');

    if (!response.hasError) {
      products = response.data;
    }

    return products;
  }

  Future fetchCustomerById(String customerId) async {
    DialogHelper.showLoading('Loading Customer');

    await RemoteServices.fetchThirdPartyById(customerId).then((value) {
      DialogHelper.hideLoading();

      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      }
      customer(value.data);
    });
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
    final FormBuilderState form = createInvoiceKey.currentState!;

    /// Check if form inputs ar valid

    if (form.validate()) {
      DialogHelper.showLoading('Creating Invoice');

      // If stock type is free text.
      if (stockType.value != 0) {
        _createInvoice();
      } else {
        /// if not free text: Check if product has stock above zero
        await RemoteServices.checkStock(selectedProduct.value.id!)
            .then((value) {
          if (value.hasError) {
            DialogHelper.hideLoading();
            SnackBarHelper.errorSnackbar(message: 'Product has no stock');
          }

          _createInvoice();
        });
      }
    }
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
        fkProductType: stockType.value == 0 ? stockType.value : null);

    /// Generate main draft
    var invoice = InvoiceModel(
        socid: customer.value.id,
        date: int.parse(dateTimeToInt(invoiceDate.value)),
        refClient: refController.text,
        type: '0',
        dateLimReglement: int.parse(dateTimeToInt(dueDate.value)),
        condReglementCode: 'RECEP',
        modeReglementCode: 'LIQ',
        lines: [line]).toJson();

    invoice.removeWhere((key, value) => value == null);

    var body = jsonEncode(invoice);

    /// Submit for draft creation

    await RemoteServices.createInvoice(body).then((value) {
      if (value.hasError) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(
          message: value.errorMessage,
        );
      }

      _validateInvoice(value.data);
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

    await RemoteServices.validateInvoice(body, invoiceId).then((value) {
      if (value.hasError) {
        SnackBarHelper.errorSnackbar(
          message: value.errorMessage,
        );
      } else {
        DialogHelper.hideLoading();
        Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {
          'invoiceId': invoiceId,
          'customerId': customer.value.id,
        });
      }
    });
  }

  ///
  ///Customer search for DropDown
  Future searchCustomer(String searchString) async {
    List<ThirdPartyModel> customers = [];

    var response =
        await RemoteServices.fetchThirdPartyList('%$searchString%', '1', 0);
    if (!response.hasError) {
      customers = response.data;
    } else {
      customers = [];
      if (response.statusCode == 408) {
        SnackBarHelper.errorSnackbar(message: 'Connection Timeout.');
      }
    }

    return customers;
  }
}

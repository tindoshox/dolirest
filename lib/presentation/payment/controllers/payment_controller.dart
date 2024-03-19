import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';

class PaymentController extends GetxController {
  final payDateController = TextEditingController();
  final dueDateController = TextEditingController();
  final receiptController = TextEditingController();
  final amountController = TextEditingController();
  final invoiceController = TextEditingController();

  final bool fromHomeScreen = Get.arguments['fromhome'];
  final String invid = Get.arguments['invid'];
  final String socid = Get.arguments['socid'];

  final paymentFormKey = GlobalKey<FormState>();
  final dropdownKey = GlobalKey<DropdownSearchState>();

  var payDate = DateTime.now().obs;
  var dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  var invoice = InvoiceModel().obs;
  var customer = ThirdPartyModel().obs;

  var amount = ''.obs;
  var receipt = ''.obs;

  @override
  void onInit() {
    if (!fromHomeScreen) {
      fetchData(socid, invid);
    }
    payDateController.text = Utils.dateTimeToString(payDate.value);
    dueDateController.text = Utils.dateTimeToString(dueDate.value);

    super.onInit();
  }

  @override
  void onClose() {
    payDateController.dispose();
    dueDateController.dispose();
    receiptController.dispose();
    amountController.dispose();
    invoiceController.dispose();
    super.onClose();
  }

  void clearInvoice() {
    customer(ThirdPartyModel());
    invoice(InvoiceModel());
    payDateController.text = Utils.dateTimeToString(payDate.value);
    dueDateController.text = Utils.dateTimeToString(dueDate.value);
  }

  /// Fetches customer and invoice data based on the given customer and invoice IDs.
  void fetchData(String customerId, String invoiceId) async {
    await _fetchCustomerById(customerId);
    await _fetchInvoiceById(invoiceId);
  }

  Future _fetchInvoiceById(String invoiceId) async {
    var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    invoice.value = box.get(invoiceId)!;
  }

  Future _fetchCustomerById(String customerId) async {
    var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
    customer.value = box.get(customerId)!;
  }

  void setPayDate() async {
    /// Shows a date picker dialog to allow the user to select the payment date.
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: payDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    /// If a date is selected, updates the payment date and due date values and displays the selected date in the text fields.
    if (selectedDate != null) {
      payDate.value = selectedDate;
      payDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      dueDate.value = selectedDate.add(const Duration(days: 30));
      dueDateController.text = Utils.dateTimeToString(dueDate.value);
    }
  }

  setDueDate() async {
    /// Shows a date picker dialog to allow the user to select the due date.
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: dueDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));

    /// If a date is selected, updates the due date value and displays the selected date in the text field.
    if (selectedDate != null) {
      dueDate.value = selectedDate;
      dueDateController.text = Utils.dateTimeToString(selectedDate);
    }
  }

  void validateAndSave() async {
    /// Retrieves the form state from the payment form key.
    final FormState form = paymentFormKey.currentState!;

    /// Validates the form and saves the payment data if the form is valid.
    if (form.validate()) {
      DialogHelper.showLoading('Processing Payment...');
      var body = jsonEncode({
        "arrayofamounts": {
          "${invoice.value.id}": {
            "amount": amount.value,
            "multicurrency_amount": ""
          }
        },
        "datepaye": Utils.dateTimeToInt(payDate.value),
        "paymentid": 4,
        "closepaidinvoices": "yes",
        "accountid": 1,
        "num_payment": receipt.value,
        "comment": "",
        "chqemetteur": "",
        "chqbank": "",
        "ref_ext": "",
        "accepthigherpayment": false
      });

      /// Processes the payment using the given payment data.
      await _processPayment(body);
    }
  }

  /// Processes the payment using the given payment data.
  _processPayment(body) async {
    await RemoteServices.addpayment(body).then((value) async {
      if (!value.hasError) {
        await _updateDueDate(invid);
        await refreshPayments(invid);
        await refreshInvoice(invid);

        if (fromHomeScreen) {
          DialogHelper.hideLoading();

          Get.snackbar(
              'Payment', '${amount.value} for ${customer.value.name} received.',
              icon: const Icon(Icons.money_sharp),
              shouldIconPulse: true,
              backgroundColor: const Color.fromARGB(255, 186, 255, 97),
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP);
          paymentFormKey.currentState?.reset();
          dropdownKey.currentState?.clear();

          clearInvoice();
        } else {
          DialogHelper.hideLoading();
          Get.back();
          SnackBarHelper.successSnackbar(message: 'Payment succesful');
        }
      } else {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: 'Payment not saved');
      }
    });
  }

  Future _updateDueDate(String invoiceId) async {
    var update =
        InvoiceModel(dateLimReglement: Utils.dateTimeToInt(dueDate.value))
            .toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    await RemoteServices.updateInvoice(invoiceId, body);
  }

  refreshPayments(invoiceId) async {
    var box = await Hive.openBox<List>(BoxName.payments.name);

    await (RemoteServices.fetchPaymentsByInvoice(invoiceId).then((value) {
      if (!value.hasError) {
        box.put(invoiceId, value.data);
      }
    }));
  }

  refreshInvoice(invoiceId) async {
    var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    await RemoteServices.fetchInvoiceById(invoiceId).then((value) async {
      if (!value.hasError) {
        box.put(invoiceId, value.data);
      }
    });
  }

  Future fetchInvoices({String searchString = ""}) async {
    List<InvoiceModel> invoices = List.empty();
    var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);

    if (searchString.isEmpty) {
      invoices = box
          .toMap()
          .values
          .toList()
          .where((invoice) => invoice.remaintopay != "0")
          .toList();
    } else {
      invoices = box
          .toMap()
          .values
          .toList()
          .where((invoice) => invoice.remaintopay != "0")
          .where((invoice) =>
              invoice.nom!.contains(searchString) ||
              invoice.ref!.contains(searchString))
          .toList();
    }

    return invoices;
  }
}

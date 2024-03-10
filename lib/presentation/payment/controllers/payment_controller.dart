import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
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

  final paymentFormKey = GlobalKey<FormBuilderState>();

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
    payDateController.text = dateTimeToString(payDate.value);
    dueDateController.text = dateTimeToString(dueDate.value);

    super.onInit();
  }

  @override
  void onClose() {
    payDateController.dispose();
    dueDateController.dispose();
    receiptController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void clearInvoice() {
    customer(ThirdPartyModel());
    invoice(InvoiceModel());
    payDateController.text = dateTimeToString(payDate.value);
    dueDateController.text = dateTimeToString(dueDate.value);
  }

  /// Fetches customer and invoice data based on the given customer and invoice IDs.
  void fetchData(String customerId, String invoiceId) async {
    await _fetchCustomerById(customerId);
    await _fetchInvoiceById(invoiceId);
  }

  Future _fetchInvoiceById(String invoiceId) async {
    var box = await Hive.openBox<InvoiceModel>('invoices');
    invoice.value = box.get(invoiceId)!;
  }

  Future _fetchCustomerById(String customerId) async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
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
      dueDateController.text = dateTimeToString(dueDate.value);
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
      dueDateController.text = dateTimeToString(selectedDate);
    }
  }

  void validateAndSave() async {
    /// Retrieves the form state from the payment form key.
    final FormBuilderState form = paymentFormKey.currentState!;

    /// Validates the form and saves the payment data if the form is valid.
    if (form.validate()) {
      DialogHelper.showLoading('Processing Payment.');
      var body = jsonEncode({
        "arrayofamounts": {
          "${invoice.value.id}": {
            "amount": amount.value,
            "multicurrency_amount": ""
          }
        },
        "datepaye": dateTimeToInt(payDate.value),
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
      _processPayment(body);
    }
  }

  /// Processes the payment using the given payment data.
  _processPayment(body) async {
    String paymentId = '';
    await _addPayment(body).then((value) async {
      paymentId = value;
      if (paymentId.isNotEmpty) {
        await _updateDueDate(invoice.value.id!);
      }
    });

    /// Validates the form and saves the payment data if the form is valid.

    if (paymentId.isNotEmpty) {
      var invoiceId = invoice.value.id;
      var customerId = invoice.value.socid;
      var customerName = customer.value.name;
      refreshPayments(invoiceId);
      refreshInvoices(invoiceId);
      paymentFormKey.currentState?.reset();
      DialogHelper.hideLoading();
      if (fromHomeScreen) {
        Get.snackbar('Payment', '${amount.value} for $customerName received.',
            icon: const Icon(Icons.money_sharp),
            shouldIconPulse: true,
            mainButton: TextButton(
                style: const ButtonStyle(),
                onPressed: () {
                  Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {
                    'invoiceId': invoiceId,
                    'customerId': customerId,
                    'refresh': true
                  });
                },
                child: const Text('Go to invoice')),
            backgroundColor: const Color.fromARGB(255, 186, 255, 97),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
        clearInvoice();
      } else {
        Get.offAndToNamed(Routes.INVOICEDETAIL, arguments: {
          'invoiceId': invoiceId,
          'customerId': customerId,
          'refresh': true,
        });
        SnackBarHelper.successSnackbar(message: 'Payment succesful');
      }
    } else {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Payment not saved');
    }
  }

  Future<String> _addPayment(String body) async {
    String paymentId = '';
    await RemoteServices.addpayment(body).then((value) {
      if (!value.hasError) {
        paymentId = value.data;
      }
    });
    return paymentId;
  }

  Future _updateDueDate(String invoiceId) async {
    var update =
        InvoiceModel(dateLimReglement: dateTimeToInt(dueDate.value)).toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    await RemoteServices.updateInvoice(invoiceId, body);
  }

  refreshPayments(invoiceId) async {
    await RemoteServices.fetchPaymentsByInvoice(invoiceId).then((value) async {
      var box = await Hive.openBox('payments');
      box.put(invoiceId, value.data);
    });
  }

  refreshInvoices(invoiceId) async {
    await RemoteServices.fetchInvoiceById(invoiceId).then((value) async {
      var box = await Hive.openBox<InvoiceModel>('invoices');
      box.put(invoiceId, value.data);
    });
  }

  Future fetchInvoices({String searchString = ""}) async {
    List<InvoiceModel> invoices = List.empty();
    var box = await Hive.openBox<InvoiceModel>('invoices');

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

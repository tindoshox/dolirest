import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentController extends GetxController {
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();

  TextEditingController payDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController receiptController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();

  final String invoiceId = Get.arguments['invoiceId'] ?? '';
  final String socid = Get.arguments['socid'] ?? '';
  final bool batch = Get.arguments['batch'] ?? false;

  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState> dropdownKey = GlobalKey<DropdownSearchState>();

  Rx<DateTime> payDate = DateTime.now().obs;
  Rx<DateTime> dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  Rx<InvoiceModel> invoice = InvoiceModel().obs;
  Rx<CustomerModel> customer = CustomerModel().obs;

  RxString amount = ''.obs;
  RxString receipt = ''.obs;
  RxList receiptNumbers = [].obs;
  RxList paymentDates = [].obs;

  @override
  void onInit() {
    if (invoiceId.isNotEmpty) {
      fetchData(socid, invoiceId);
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
    customer(CustomerModel());
    invoice(InvoiceModel());
    payDateController.text = Utils.dateTimeToString(payDate.value);
    dueDateController.text = Utils.dateTimeToString(dueDate.value);
  }

  /// Fetches customer and invoice data based on the given customer and invoice IDs.
  void fetchData(String customerId, String invoiceId) async {
    await _fetchCustomerById(customerId);
    await _fetchInvoiceById(invoiceId);
    await _fetchPayments(invoiceId);
  }

  _fetchInvoiceById(String invoiceId) {
    invoice.value = storage.getInvoice(invoiceId)!;
  }

  Future _fetchPayments(invoiceId) async {
    List<PaymentModel> list = storage.getPaymentList(invoiceId: invoiceId);

    receiptNumbers.value =
        list.map((payment) => payment.num.toString()).toList();

    paymentDates.value = list
        .map((payment) => DateFormat('dd-MM-yyyy').format(payment.date!))
        .toList();
  }

  _fetchCustomerById(String customerId) {
    customer.value = storage.getCustomer(customerId)!;
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
      String body = jsonEncode({
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
    final result = await repository.addPayment(body: body);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Payment not saved');
    }, (p) async {
      await _updateDueDate(invoice.value.id);
      await _refreshPayments(invoice.value.id);
      await _refreshInvoice(invoice.value.id);

      if (batch) {
        DialogHelper.hideLoading();

        SnackBarHelper.successSnackbar(
            title: 'Payment',
            message: '${amount.value} for ${customer.value.name} received.');
        paymentFormKey.currentState?.reset();
        dropdownKey.currentState?.clear();
        clearInvoice();
      } else {
        DialogHelper.hideLoading();
        Get.back();
        SnackBarHelper.successSnackbar(message: 'Payment successful');
      }
    });
  }

  Future _updateDueDate(String invoiceId) async {
    var update =
        InvoiceModel(dateLimReglement: Utils.dateTimeToInt(dueDate.value))
            .toJson();
    update.removeWhere((key, value) => value == null);

    String body = jsonEncode(update);

    await repository.updateInvoice(invoiceId: invoiceId, body: body);
  }

  _refreshPayments(invoiceId) async {
    final result =
        await (repository.fetchPaymentsByInvoice(invoiceId: invoiceId));
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (payments) {
      for (var payment in payments) {
        PaymentModel p = PaymentModel(
          amount: payment.amount,
          type: payment.type,
          date: payment.date,
          num: payment.num,
          fkBankLine: payment.fkBankLine,
          ref: payment.ref,
          invoiceId: invoiceId,
          refExt: payment.refExt,
        );
        storage.storePayment(payment.ref, p);
      }
    });
  }

  _refreshInvoice(invoiceId) async {
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

  fetchInvoices() {
    return storage
        .getInvoiceList()
        .where((invoice) => invoice.remaintopay != "0")
        .toList();
  }
}

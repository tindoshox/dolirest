import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentController extends GetxController {
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();
  final NetworkService network = Get.find();
  final DataRefreshService data = Get.find();

  TextEditingController payDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController receiptController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();

  final int? entityId = Get.arguments['entityId'];
  bool batch = Get.arguments['batch'] ?? true;

  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState> dropdownKey = GlobalKey<DropdownSearchState>();

  Rx<DateTime> payDate = DateTime.now().obs;
  Rx<DateTime> dueDate = DateTime.now().add(const Duration(days: 31)).obs;

  var invoice = InvoiceEntity().obs;
  var customer = CustomerEntity().obs;
  var customers = <CustomerEntity>[].obs;
  var invoices = <InvoiceEntity>[].obs;

  var amount = ''.obs;
  var receipt = ''.obs;
  var receiptNumbers = [].obs;
  var paymentDates = [].obs;
  var connected = false.obs;

  @override
  void onInit() {
    everAll([network.connected, data.invoices, data.customers], (_) {
      connected = network.connected;
      invoice.value = data.invoices.firstWhere((i) => i.id == entityId);
      customer.value =
          data.customers.firstWhere((c) => c.customerId == invoice.value.socid);
      customers = data.customers;
      invoices = data.invoices;
    });

    connected = network.connected;
    if (entityId == null) {
      customers = data.customers;
      invoices = data.invoices;
    }
    if (entityId != null) {
      invoice.value = data.invoices.firstWhere((i) => i.id == entityId);
      customer.value =
          data.customers.firstWhere((c) => c.customerId == invoice.value.socid);
    }
    payDateController.text = Utils.dateTimeToDMY(payDate.value);
    dueDateController.text = Utils.dateTimeToDMY(dueDate.value);

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
    invoice.value = InvoiceEntity();
    customer.value = CustomerEntity();
    payDateController.text = Utils.dateTimeToDMY(payDate.value);
    dueDateController.text = Utils.dateTimeToDMY(dueDate.value);
    receiptController.clear();
    amountController.clear();
  }

  void fetchData(InvoiceEntity selectedInvoice) async {
    invoice.value = selectedInvoice;
    await _fetchCustomerById(selectedInvoice.socid);
    await _fetchPayments(selectedInvoice.documentId);
  }

  Future _fetchPayments(String invoiceId) async {
    List<PaymentEntity> list = storage.paymentBox
        .query(PaymentEntity_.invoiceId.equals(invoiceId))
        .build()
        .find();

    receiptNumbers.value =
        list.map((payment) => payment.num.toString()).toList();

    paymentDates.value =
        list.map((payment) => Utils.dateTimeToDMY(payment.date)).toList();
  }

  Future _fetchCustomerById(String customerId) async {
    customer.value = storage.getCustomer(customerId)!;
  }

  void setPayDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: payDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (selectedDate != null) {
      payDate.value = selectedDate;
      payDateController.text = Utils.dateTimeToDMY(selectedDate);
      dueDate.value = selectedDate.add(const Duration(days: 30));
      dueDateController.text = Utils.dateTimeToDMY(dueDate.value);
    }
  }

  Future<void> setDueDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: dueDate.value,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));

    if (selectedDate != null) {
      dueDate.value = selectedDate;
      dueDateController.text = Utils.dateTimeToDMY(selectedDate);
    }
  }

  void validateAndSave() async {
    final FormState form = paymentFormKey.currentState!;

    if (form.validate()) {
      DialogHelper.showLoading('Processing payment...');
      String body = jsonEncode({
        "arrayofamounts": {
          invoice.value.documentId: {
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

      await _processPayment(body);
    }
  }

  Future<void> _processPayment(String body) async {
    final result = await repository.addPayment(body: body);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: 'Payment not saved');
    }, (p) async {
      DialogHelper.updateMessage('Updating due date ..');
      await _updateDueDate(invoice.value.documentId);
      DialogHelper.updateMessage('Reloading data ..');
      await _refreshPayments(invoice.value.documentId);

      await _refreshInvoice(invoice.value.documentId);

      if (batch == true) {
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

  Future<void> _refreshPayments(String invoiceId) async {
    final result =
        await (repository.fetchPaymentsByInvoice(invoiceId: invoiceId));
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (payments) {
      storage.storePayments(payments).then((apiPayments) {
        if (apiPayments.isNotEmpty) {
          storage.cleanupPayments(apiPayments, invoiceId);
        }
      });
    });
  }

  Future<void> _refreshInvoice(String invoiceId) async {
    final result = await repository.fetchInvoiceById(invoiceId);

    result.fold((failure) {
      if (Get.isDialogOpen == true) {
        DialogHelper.hideLoading();
      }
      Get.back();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (invoice) {
      storage.storeInvoice(invoice);
    });
  }

  List<InvoiceEntity> fetchInvoices() {
    var openInvoices = storage.invoiceBox
        .query(InvoiceEntity_.paye
            .equals(PaidStatus.unpaid)
            .and(InvoiceEntity_.type.equals(DocumentType.invoice))
            .and(InvoiceEntity_.status.equals(ValidationStatus.validated)))
        .build()
        .find();

    for (var i in openInvoices) {
      final CustomerEntity? c = storage.customerBox
          .query(CustomerEntity_.customerId.equals(i.socid))
          .build()
          .findFirst();
      if (c != null) {
        i.name = c.name;
      }
    }
    return openInvoices;
  }
}

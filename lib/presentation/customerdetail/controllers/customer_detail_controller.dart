import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dolirest/infrastructure/dal/models/build_statement_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/utils.dart' show Utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:open_filex/open_filex.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageService storage = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final DocumentRepository documentRepository = Get.find();
  final DataRefreshContoller _dataRefreshContoller = Get.find();
  final String customerId = Get.arguments['customerId'];
  var customer = CustomerModel().obs;
  var invoices = <InvoiceModel>[].obs;
  var moduleEnabledStatement = false.obs;
  var startDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  var endDate = DateTime.now().obs;

  GlobalKey<FormState> dateFormkey = GlobalKey<FormState>();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  final List<Tab> customerTabs = [
    const Tab(text: 'Details'),
    const Tab(text: 'Invoices')
  ];
  RxInt tabIndex = 0.obs;
  late TabController tabController;
  late TargetPlatform? platform;
  late bool permissionReady;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    tabController = TabController(length: customerTabs.length, vsync: this);
    startDateController.text = Utils.dateTimeToDMY(startDate.value);
    endDateController.text = Utils.dateTimeToDMY(endDate.value);
    moduleEnabledStatement.value =
        storage.getEnabledModules().contains('customerstatement');
    _watchBoxes();
    _updateCustomer();
    _updateInvoices();
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    super.onInit();
  }

  @override
  void onReady() {
    if (invoices.isEmpty) {
      refreshCustomerInvoiceData();
    }
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  void _watchBoxes() {
    storage.customersListenable().addListener(_updateCustomer);
    storage.invoicesListenable().addListener(_updateInvoices);
  }

  void _updateCustomer() {
    final c = storage.getCustomer(customerId);
    if (c != null) {
      customer.value = c;
    }
  }

  void _updateInvoices() {
    invoices.value = storage.getInvoiceList(customerId: customerId);
  }

  // Fetch invoice data from server
  Future<void> refreshCustomerInvoiceData() async {
    isLoading.value = true;
    await _dataRefreshContoller.syncInvoices(customerId: customerId);
    isLoading.value = false;
  }

  Future<void> deleteCustomer() async {
    DialogHelper.showLoading('Deleting customer...');
    final result = await customerRepository.deleteCustomer(customerId);
    result.fold(
      (failure) {
        DialogHelper.hideLoading();
        if (failure.code == 404) {
          storage.deleteCustomer(customerId);
          Get.back();
          SnackBarHelper.successSnackbar(message: 'Customer deleted');
        } else {
          SnackBarHelper.errorSnackbar(message: failure.message);
        }
      },
      (res) {
        DialogHelper.hideLoading();
        storage.deleteCustomer(customerId);
        Get.back();
        SnackBarHelper.successSnackbar(message: 'Customer deleted');
      },
    );
  }

  Future generateStatement() async {
    permissionReady = await Utils.checkPermission(platform);
    Get.back();
    DialogHelper.showLoading('Downloading document...');
    final params = BuildStatementRequestModel(
      socid: customerId,
      startdate: startDate.value,
      enddate: endDate.value,
    ).toJson();

    String body = jsonEncode(params);

    if (permissionReady) {
      final result = await documentRepository.buildStatement(body);
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: failure.message);
      }, (document) {
        Utils.createFileFromString(
                document.content, '${customer.value.name}_statement.pdf')
            .then((value) {
          DialogHelper.hideLoading();
          OpenFilex.open(value);
        });
      });
    } else {
      DialogHelper.hideLoading();
      Get.snackbar('Permission Error', 'Download Failed');
    }

    DialogHelper.hideLoading();
  }

  ///Set values for invoice date
  void setStartDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: startDate.value,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));

    startDate.value = selectedDate!;
    startDateController.text = Utils.dateTimeToDMY(selectedDate);
  }

  ///
  ///
  ///Set values Due date
  void setEndDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: Get.context!,
        initialDate: endDate.value,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050));

    endDate.value = selectedDate!;
    endDateController.text = Utils.dateTimeToDMY(selectedDate);
  }
}

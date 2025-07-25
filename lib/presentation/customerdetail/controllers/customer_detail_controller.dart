import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dolirest/infrastructure/dal/models/build_statement_request_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/document_repository.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart' show Utils;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final NetworkService _network = Get.find();
  final StorageService _storage = Get.find();
  final CustomerRepository _customerRepository = Get.find();
  final DocumentRepository _documentRepository = Get.find();
  final DataRefreshService _data = Get.find();
  var customer = CustomerEntity().obs;
  var invoices = <InvoiceEntity>[].obs;
  var moduleEnabledStatement = false.obs;
  var startDate = DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  var endDate = DateTime.now().obs;
  var connected = false.obs;
  GlobalKey<FormState> dateFormkey = GlobalKey<FormState>();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  final List<Tab> customerTabs = [
    const Tab(text: 'Details'),
    const Tab(text: 'Invoices')
  ];
  RxInt tabIndex = 0.obs;
  late TabController tabController;
  late TargetPlatform? _platform;
  late bool _permissionReady;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    ever(_network.connected, (_) {
      connected = _network.connected;
    });

    connected = _network.connected;

    customer.bindStream(_storage.customerBox
        .query(CustomerEntity_.id.equals(Get.arguments['entityId']))
        .watch()
        .map((query) {
      return query.findFirst()!;
    }));

    customer.value =
        _data.customers.firstWhere((c) => c.id == Get.arguments['entityId']);

    invoices.value = _data.invoices
        .where((i) => i.socid == customer.value.customerId)
        .toList();
    if (Platform.isAndroid) {
      _platform = TargetPlatform.android;
    } else {
      _platform = TargetPlatform.iOS;
    }
    tabController = TabController(length: customerTabs.length, vsync: this);
    startDateController.text = Utils.dateTimeToDMY(startDate.value);
    endDateController.text = Utils.dateTimeToDMY(endDate.value);
    moduleEnabledStatement.value = _storage.settingsBox
        .get(SettingId.moduleSettingId)!
        .listValue!
        .contains('customerstatement');

    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    super.onInit();
  }

  @override
  void onReady() async {
    if (connected.value) {
      await refreshData();
    }

    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  // Fetch invoice data from server
  Future<void> refreshData() async {
    isLoading.value = true;
    await _customerRepository.fetchCustomerById(customer.value.customerId);
    await _data.syncInvoices(customerId: customer.value.customerId);

    isLoading.value = false;
  }

  Future generateStatement() async {
    _permissionReady = await Utils.checkPermission(_platform);
    Get.back();
    DialogHelper.showLoading('Downloading document...');
    final params = BuildStatementRequestModel(
      socid: customer.value.id,
      startdate: startDate.value,
      enddate: endDate.value,
    ).toJson();

    String body = jsonEncode(params);

    if (_permissionReady) {
      final result = await _documentRepository.buildStatement(body);
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

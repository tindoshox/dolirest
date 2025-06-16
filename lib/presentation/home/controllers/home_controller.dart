import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/module_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NetworkService network = Get.find();
  final StorageService storage = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CompanyRepository companyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final ModuleRepository moduleRepository = Get.find();
  final DataRefreshService data = Get.find();

  var isLoading = false.obs;
  var connected = false.obs;
  var user = UserModel().obs;
  var company = ''.obs;
  var noInvoiceCustomers = 0.obs;
  var cashflow = 0.obs;
  var openInvoices = 0.obs;
  var draftInvoices = 0.obs;
  var dueTodayInvoices = 0.obs;
  var overDueInvoices = 0.obs;
  var salesInvoices = 0.obs;
  var enabledModules = <String>[].obs;

  @override
  void onInit() {
    _updateUser();
    _updateModules();
    _updateCompany();

    everAll([data.customers, data.cashflow, data.invoices, network.connected],
        (_) {
      var nic = <CustomerEntity>[];
      for (var customer in data.customers) {
        var invoices =
            data.invoices.where((i) => i.socid == customer.customerId);
        if (invoices.isEmpty) {
          nic.add(customer);
        }
      }
      noInvoiceCustomers.value = nic.length;
      cashflow = data.cashflow;
      connected = network.connected;

      openInvoices.value = data.invoices
          .where((i) =>
              i.type == DocumentType.invoice &&
              i.paye == PaidStatus.unpaid &&
              i.remaintopay != "0" &&
              i.status == ValidationStatus.validated)
          .length;
      draftInvoices.value = data.invoices
          .where((invoice) => invoice.status == ValidationStatus.draft)
          .length;
      overDueInvoices.value = data.invoices
          .where((i) =>
              i.type == DocumentType.invoice &&
              i.paye == PaidStatus.unpaid &&
              i.remaintopay != "0" &&
              i.status == ValidationStatus.validated &&
              Utils.intToDateTime(i.dateLimReglement)
                  .isBefore(DateTime.now().subtract(Duration(days: 31))))
          .length;

      salesInvoices.value = data.invoices
          .where((invoice) =>
              Utils.isSameMonth(
                  Utils.intToDateTime(invoice.date), DateTime.now()) &&
              invoice.type == DocumentType.invoice)
          .length;
      dueTodayInvoices.value = data.invoices
          .where((i) =>
              i.type == DocumentType.invoice &&
              i.remaintopay != "0" &&
              i.paye == PaidStatus.unpaid &&
              Utils.intToDateTime(i.dateLimReglement).day ==
                  DateTime.now().day &&
              Utils.intToDateTime(i.dateLimReglement)
                  .isBefore(DateTime.now().add(Duration(days: 1))))
          .length;
    });

    var nic = <CustomerEntity>[];
    for (var customer in data.customers) {
      var invoices = data.invoices.where((i) => i.socid == customer.customerId);
      if (invoices.isEmpty) {
        nic.add(customer);
      }
    }
    noInvoiceCustomers.value = nic.length;
    cashflow = data.cashflow;
    connected = network.connected;

    openInvoices.value = data.invoices
        .where((i) =>
            i.type == DocumentType.invoice &&
            i.paye == PaidStatus.unpaid &&
            i.remaintopay != "0" &&
            i.status == ValidationStatus.validated)
        .length;
    draftInvoices.value = data.invoices
        .where((invoice) => invoice.status == ValidationStatus.draft)
        .length;
    overDueInvoices.value = data.invoices
        .where((i) =>
            i.type == DocumentType.invoice &&
            i.paye == PaidStatus.unpaid &&
            i.remaintopay != "0" &&
            i.status == ValidationStatus.validated &&
            Utils.intToDateTime(i.dateLimReglement)
                .isBefore(DateTime.now().subtract(Duration(days: 31))))
        .length;

    salesInvoices.value = data.invoices
        .where((invoice) =>
            Utils.isSameMonth(
                Utils.intToDateTime(invoice.date), DateTime.now()) &&
            invoice.type == DocumentType.invoice)
        .length;
    dueTodayInvoices.value = data.invoices
        .where((i) =>
            i.type == DocumentType.invoice &&
            i.remaintopay != "0" &&
            Utils.dateOnly(Utils.intToDateTime(i.dateLimReglement)) ==
                Utils.dateOnly(DateTime.now()))
        .length;

    super.onInit();
  }

  @override
  void onReady() {
    if ((storage.customerBox.getAll().isEmpty ||
            storage.invoiceBox.getAll().isEmpty) &&
        !data.refreshing.value) {
      forceRefresh();
    }

    if (enabledModules.isEmpty) {
      _refreshModules();
    }

    super.onReady();
  }

  void _updateCompany() {
    if (storage.companyBox.get(1) == null) {
      _refreshCompanyData();
    }
    company.value = storage.companyBox.get(1)?.name ?? '';
  }

  Future _refreshCompanyData() async {
    final result = await companyRepository.fetchCompany();
    result.fold((failure) {}, (entity) {
      storage.companyBox.put(entity);
    });
  }

  void _updateUser() {
    user.value = storage.userBox.get(1) ?? UserModel();
  }

  void forceRefresh() async {
    SnackBarHelper.successSnackbar(message: 'Refreshing data');

    data.forceRefresh();
  }

  void _updateModules() {
    enabledModules.value =
        storage.settingsBox.get(SettingId.moduleSettingId)?.listValue ?? [];
  }

  Future<void> _refreshModules() async {
    final result = await moduleRepository.fetchEnabledModules();
    result.fold((failure) {}, (modules) {
      storage.settingsBox.put(SettingsModel(
          id: SettingId.moduleSettingId, name: 'modules', listValue: modules));
    });
  }
}

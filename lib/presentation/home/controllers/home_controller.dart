import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/module_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart' show Utils;
import 'package:flutter/material.dart' show DateUtils;
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NetworkController networkController = Get.find();
  final StorageService storage = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CompanyRepository companyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final ModuleRepository moduleRepository = Get.find();
  final DataRefreshContoller dataRefreshContoller = Get.find();

  var isLoading = false.obs;
  var user = UserModel().obs;
  var company = ''.obs;
  var noInvoiceCustomers = <CustomerEntity>[].obs;
  var dayCashflow = <PaymentModel>[].obs;
  var drafts = 0.obs;
  var openInvoices = 0.obs;
  var overDues = 0.obs;
  var sales = 0.obs;
  var dueToday = <InvoiceEntity>[].obs;
  var enabledModules = <String>[].obs;

  @override
  void onInit() {
    _updateNoInvoiceCustomers();
    _updateDayCashflow();
    _updateInvoiceStats();
    _updateUser();
    _updateModules();
    _updateCompany();

    super.onInit();
  }

  @override
  void onReady() {
    if (openInvoices.value == 0 && !dataRefreshContoller.refreshing.value) {
      forceRefresh();
    }

    if (enabledModules.isEmpty) {
      _refreshModules();
    }

    super.onReady();
  }

  void _updateCompany() {
    if (storage.getCompany(1) == null) {
      _refreshCompanyData();
    }
    company.value = storage.getCompany(1)?.name ?? '';
  }

  Future _refreshCompanyData() async {
    final result = await companyRepository.fetchCompany();
    result.fold((failure) {}, (entity) {
      storage.storeCompany(entity);
    });
  }

  void _updateUser() {
    user.value = storage.getUser(1) ?? UserModel();
  }

  void forceRefresh() async {
    if (!dataRefreshContoller.refreshing.value) {
      isLoading.value = true;
      DialogHelper.showLoading();
      await dataRefreshContoller.forceRefresh().then((v) {
        DialogHelper.hideLoading();
        isLoading.value = false;
      });
    }
  }

  void _updateModules() {
    enabledModules.value =
        storage.getEnabledModules(SettingId.moduleSettingId)?.listValue ?? [];
  }

  Future<void> _refreshModules() async {
    final result = await moduleRepository.fetchEnabledModules();
    result.fold((failure) {}, (modules) {
      storage.storeEnabledModules(SettingsModel(
          id: SettingId.moduleSettingId, name: 'modules', listValue: modules));
    });
  }

  void _updateNoInvoiceCustomers() {
    final customers = storage.getCustomerList(); // or box.values.toList()
    final result = <CustomerEntity>[];

    for (var customer in customers) {
      final invoices = storage.getInvoiceList(customerId: customer.customerId);
      if (invoices.isEmpty) {
        result.add(customer);
      }
    }

    noInvoiceCustomers.value = result;
  }

  void _updateDayCashflow() {
    final payments = storage.getPaymentList();

    //Day Cashflow
    dayCashflow.value = payments
        .where((p) =>
            DateUtils.dateOnly(p.date) == DateUtils.dateOnly(DateTime.now()))
        .toList();
  }

  void _updateInvoiceStats() {
    final invoices = storage.getInvoiceList();
    drafts.value = invoices
        .where((invoice) => invoice.status == ValidationStatus.draft)
        .length;
    openInvoices.value = invoices
        .where((invoice) =>
            invoice.type == DocumentType.invoice &&
            invoice.remaintopay != "0" &&
            invoice.status == ValidationStatus.validated &&
            invoice.paye == PaidStatus.unpaid)
        .length;

    sales.value = invoices
        .where((invoice) =>
            DateUtils.isSameMonth(
                Utils.intToDateTime(invoice.date!), DateTime.now()) &&
            invoice.type == DocumentType.invoice)
        .length;
    invoices.removeWhere((i) => i.dateLimReglement == null);
    overDues.value = invoices
        .where((invoice) =>
            invoice.type == DocumentType.invoice &&
            invoice.remaintopay != "0" &&
            Utils.intToDateTime(invoice.dateLimReglement!)
                .isBefore(DateTime.now().subtract(Duration(days: 31))))
        .length;

    dueToday.value = invoices
        .where((invoice) =>
            invoice.type == DocumentType.invoice &&
            invoice.remaintopay != "0" &&
            Utils.intToDateTime(invoice.dateLimReglement!).day ==
                DateTime.now().day)
        .toList();
  }
}

import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/module_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
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
  var moduleReportsEnabled = false.obs;
  var user = UserModel().obs;
  var company = CompanyModel().obs;

  var noInvoiceCustomers = <CustomerModel>[].obs;
  var dayCashflow = <PaymentModel>[].obs;
  var drafts = 0.obs;
  var openInvoices = 0.obs;
  var overDues = 0.obs;
  var sales = 0.obs;
  var dueToday = <InvoiceModel>[].obs;

  @override
  void onInit() async {
    await _fetchUser();
    await _fetchEnabledModules();
    _watchBoxes();
    _updateNoInvoiceCustomers();
    _updateDayCashflow();
    _updateInvoiceStats();
    moduleReportsEnabled.value =
        storage.getEnabledModules().contains('reports');
    super.onInit();
  }

  @override
  void onReady() async {
    await _fetchCompany();
    var invoices = storage.getInvoiceList().length;
    if (invoices == 0) {
      await forceRefresh();
    }

    super.onReady();
  }

  _fetchCompany() {
    if (storage.getCompany() == null) {
      _refreshCompanyData();
    } else {
      company.value = storage.getCompany()!;
    }
  }

  Future _refreshCompanyData() async {
    final result = await companyRepository.fetchCompany();
    result.fold((failure) {}, (entity) {
      storage.storeCompany(entity);
      company.value = entity;
    });
  }

  _fetchUser() async {
    if (storage.getUser() == null) {
      await _refreshUserData();
    } else {
      user.value = storage.getUser()!;
    }
  }

  Future<void> _refreshUserData() async {
    final result = await userRepository.login();
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (u) {
      storage.storeUser(u);
      user.value = u;
    });
  }

  forceRefresh() async {
    await dataRefreshContoller.forceRefresh();
  }

  _fetchEnabledModules() async {
    final result = await moduleRepository.fetchEnabledModules();
    result.fold((failure) => storage.storeEnabledModules([]),
        (modules) => storage.storeEnabledModules(modules));
  }

  void _watchBoxes() {
    storage.customersListenable().addListener(_updateNoInvoiceCustomers);
    storage.invoicesListenable().addListener(_updateNoInvoiceCustomers);
    storage.paymentsListenable().addListener(_updateDayCashflow);
    storage.invoicesListenable().addListener(_updateInvoiceStats);
  }

  void _updateNoInvoiceCustomers() {
    final customers = storage.getCustomerList(); // or box.values.toList()
    final result = <CustomerModel>[];

    for (var customer in customers) {
      final invoices = storage.getInvoiceList(customerId: customer.id);
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
            DateUtils.dateOnly(p.date!) == DateUtils.dateOnly(DateTime.now()))
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

    dueToday.value = invoices
        .where((invoice) =>
            invoice.remaintopay != "0" &&
            Utils.intToDateTime(invoice.dateLimReglement!).day ==
                DateTime.now().day)
        .toList();
    sales.value = invoices
        .where((invoice) => DateUtils.isSameMonth(
            Utils.intToDateTime(invoice.date!), DateTime.now()))
        .length;
    overDues.value = invoices
        .where((invoice) =>
            invoice.remaintopay != "0" &&
            Utils.intToDateTime(invoice.dateLimReglement!)
                .isBefore(DateTime.now().subtract(Duration(days: 31))))
        .length;
  }
}

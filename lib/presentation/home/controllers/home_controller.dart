import 'dart:async';

import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/models/user_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/company_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/module_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/server_reachablility.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:get/get.dart' hide Rx;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

class HomeController extends GetxController {
  final NetworkService _network = Get.find();
  final StorageService _storage = Get.find();
  final CompanyRepository _companyRepository = Get.find();
  final ModuleRepository _moduleRepository = Get.find();
  final DataRefreshService _data = Get.find();
  final ServerReachability _reachability = Get.find();

  var isLoading = false.obs;
  var connected = true.obs;
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
  var refreshing = false.obs;
  late PackageInfo packageInfo;

  @override
  Future<void> onInit() async {
    packageInfo = await _packageInfo();
    _updateUser();
    _updateCompany();

    everAll([
      _data.customers,
      _data.cashflow,
      _data.invoices,
      _network.connected,
    ], (_) {
      cashflow = _data.cashflow;
      connected = _network.connected;

      openInvoices.value = _data.invoices
          .where((i) =>
              i.type == DocumentType.invoice &&
              i.paye == PaidStatus.unpaid &&
              i.remaintopay != "0" &&
              i.status == ValidationStatus.validated)
          .length;
      draftInvoices.value = _data.invoices
          .where((invoice) => invoice.status == ValidationStatus.draft)
          .length;
      overDueInvoices.value = _data.invoices
          .where((i) =>
              i.type == DocumentType.invoice &&
              i.paye == PaidStatus.unpaid &&
              i.remaintopay != "0" &&
              i.status == ValidationStatus.validated &&
              Utils.intToDateTime(i.dateLimReglement)
                  .isBefore(DateTime.now().subtract(Duration(days: 31))))
          .length;

      salesInvoices.value = _data.invoices
          .where((invoice) =>
              Utils.isSameMonth(
                  Utils.intToDateTime(invoice.date), DateTime.now()) &&
              invoice.type == DocumentType.invoice)
          .length;
      dueTodayInvoices.value = _data.invoices
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

    cashflow = _data.cashflow;
    _network.connected.value = await _reachability.checkServerReachability();
    connected = _network.connected;
    openInvoices.value = _data.invoices
        .where((i) =>
            i.type == DocumentType.invoice &&
            i.paye == PaidStatus.unpaid &&
            i.remaintopay != "0" &&
            i.status == ValidationStatus.validated)
        .length;
    draftInvoices.value = _data.invoices
        .where((invoice) => invoice.status == ValidationStatus.draft)
        .length;
    overDueInvoices.value = _data.invoices
        .where((i) =>
            i.type == DocumentType.invoice &&
            i.paye == PaidStatus.unpaid &&
            i.remaintopay != "0" &&
            i.status == ValidationStatus.validated &&
            Utils.intToDateTime(i.dateLimReglement)
                .isBefore(DateTime.now().subtract(Duration(days: 31))))
        .length;

    salesInvoices.value = _data.invoices
        .where((invoice) =>
            Utils.isSameMonth(
                Utils.intToDateTime(invoice.date), DateTime.now()) &&
            invoice.type == DocumentType.invoice)
        .length;
    dueTodayInvoices.value = _data.invoices
        .where((i) =>
            i.type == DocumentType.invoice &&
            i.remaintopay != "0" &&
            Utils.dateOnly(Utils.intToDateTime(i.dateLimReglement)) ==
                Utils.dateOnly(DateTime.now()))
        .length;

    noInvoiceCustomers.bindStream(
      Rx.combineLatest2(
        _storage.customerBox.query().watch(triggerImmediately: true),
        _storage.invoiceBox.query().watch(triggerImmediately: true),
        (Query<CustomerEntity> customerQuery, Query<InvoiceEntity> _) {
          int count = 0;
          final customers = customerQuery.find();
          for (var customer in customers) {
            final invs = _storage.invoiceBox
                .query(InvoiceEntity_.socid.equals(customer.customerId))
                .build()
                .find();
            if (invs.isEmpty) {
              count++;
            }
          }
          return count;
        },
      ),
    );

    company.bindStream(_storage.companyBox
        .query(CompanyModel_.id.equals(1))
        .watch(triggerImmediately: true)
        .map((query) {
      return query.findFirst()?.name ?? '';
    }));

    company.value = _storage.companyBox.get(1)?.name ?? '';
    super.onInit();

    enabledModules.bindStream(_storage.settingsBox
        .query(SettingsModel_.id.equals(SettingId.moduleSettingId))
        .watch(triggerImmediately: true)
        .map((query) {
      return query.findFirst()?.listValue ?? [];
    }));

    enabledModules.value =
        _storage.settingsBox.get(SettingId.moduleSettingId)?.listValue ?? [];
  }

  @override
  void onReady() {
    if (_storage.customerBox.getAll().isEmpty ||
        _storage.invoiceBox.getAll().isEmpty) {
      debugPrint('forcing');

      forceRefresh();
    }

    if (enabledModules.isEmpty) {
      _refreshModules();
    }

    super.onReady();
  }

  void _updateCompany() {
    if (_storage.companyBox.get(1) == null) {
      _refreshCompanyData();
    }
  }

  Future _refreshCompanyData() async {
    final result = await _companyRepository.fetchCompany();
    result.fold((failure) {}, (entity) {
      entity.id = 1;
      _storage.companyBox.put(entity);
    });
  }

  void _updateUser() {
    user.value = _storage.userBox.get(1) ?? UserModel();
  }

  Future forceRefresh() async {
    //  SnackBarHelper.successSnackbar(message: 'Refreshing data');
    refreshing.value = true;
    await _data.forceRefresh().then((value) => refreshing.value = false);
  }

  void _updateModules() {
    enabledModules.value =
        _storage.settingsBox.get(SettingId.moduleSettingId)?.listValue ?? [];
  }

  Future<void> _refreshModules() async {
    final result = await _moduleRepository.fetchEnabledModules();
    result.fold((failure) {}, (modules) {
      _storage.settingsBox.put(SettingsModel(
          id: SettingId.moduleSettingId, name: 'modules', listValue: modules));
    });
  }

  Future<bool> refreshConnection() async {
    bool result = await _network.reachablility.checkServerReachability();
    if (result == true) {
      connected.value = true;
    } else {
      SnackBarHelper.errorSnackbar(message: 'Unable to reach server');
    }
    return result;
  }

  void saveThemeSetting(String strValue) {
    _storage.settingsBox.put(SettingsModel(
        id: SettingId.themeModeId, name: StorageKey.theme, strValue: strValue));
  }

  Future<PackageInfo> _packageInfo() async {
    return await PackageInfo.fromPlatform();
  }
}

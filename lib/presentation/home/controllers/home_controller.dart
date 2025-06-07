import 'dart:async';

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
import 'package:get/get.dart';

class HomeController extends GetxController {
  final NetworkController networkController = Get.find();
  final StorageService storage = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CompanyRepository companyRepository = Get.find();
  final UserRepository userRepository = Get.find();
  final ModuleRepository moduleRepository = Get.find();
  final DataRefreshService dataRefreshContoller = Get.find();

  var isLoading = false.obs;
  var user = UserModel().obs;
  var company = ''.obs;

  var enabledModules = <String>[].obs;

  @override
  void onInit() {
    _updateUser();
    _updateModules();
    _updateCompany();

    super.onInit();
  }

  @override
  void onReady() {
    if ((storage.customerBox.getAll().isEmpty ||
            storage.invoiceBox.getAll().isEmpty) &&
        !dataRefreshContoller.refreshing.value) {
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
    DialogHelper.showLoading();
    await dataRefreshContoller.forceRefresh().then((v) {
      DialogHelper.hideLoading();
    });
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

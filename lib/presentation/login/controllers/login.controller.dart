import 'package:dolirest/config_dev.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/auth_service.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final NetworkService network = Get.find();
  final StorageService storage = Get.find();
  final UserRepository userRepositoty = Get.find();
  final auth = Get.find<AuthService>();
  final dio = Get.find<DioService>();
  var serverUrl = ''.obs;
  var token = ''.obs;
  GlobalKey<FormState> serverFormKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController apiController = TextEditingController();
  @override
  void onInit() {
    if (kDebugMode) {
      urlController.text = ConfigDev.url;
      apiController.text = ConfigDev.token;
    }
    super.onInit();
  }

  @override
  void onClose() {
    urlController.dispose();
    apiController.dispose();
    super.onClose();
  }

  /// Validates the form and adds the server if the form is valid.
  Future validate(BuildContext context) async {
    final FormState form = serverFormKey.currentState!;

    if (form.validate()) {
      DialogHelper.showLoading('Verifying Server Info...');
      final newUrl = 'https://${urlController.text.trim()}';
      final newToken = apiController.text.trim();

      auth.updateCredentials(
          newUrl, newToken); // <-- triggers Dio reconfiguration automatically

      _writeStore(newUrl, newToken);
      final result = await userRepositoty.login(url: newUrl, token: newToken);

      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: failure.message);
        _clearStorage();
      }, (user) async {
        storage.userBox.put(user);
        DialogHelper.hideLoading();
        network.connected.value = true;
        Get.toNamed(Routes.HOME);
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore(String url, String token) {
    storage.settingsBox.put(SettingsModel(
        id: SettingId.urlSettingId, name: StorageKey.url, strValue: url));
    storage.settingsBox.put(SettingsModel(
        id: SettingId.tokenSettingId, name: StorageKey.token, strValue: token));
  }

  void _clearStorage() {
    storage.clearAll();
  }

  void getClipboardApiKey() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      apiController.text = clipboardText;
    }
  }

  void getClipboardUrl() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      urlController.text = clipboardText;
    }
  }
}

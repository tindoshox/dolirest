import 'package:dolirest/config_dev.dart';
import 'package:dolirest/infrastructure/dal/models/settings_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/auth_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final StorageService _storage = Get.find();
  final UserRepository _userRepositoty = Get.find();
  final _auth = Get.find<AuthService>();
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

  Future validate(BuildContext context) async {
    final FormState form = serverFormKey.currentState!;

    if (form.validate()) {
      DialogHelper.showLoading('Verifying Server Info...');
      final newUrl = 'https://${urlController.text.trim()}';
      final newToken = apiController.text.trim();

      _auth.updateCredentials(newUrl, newToken);

      _writeStore(newUrl, newToken);
      final result = await _userRepositoty.login(url: newUrl, token: newToken);

      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: failure.message);
        _clearStorage();
      }, (user) async {
        _storage.userBox.put(user);
        DialogHelper.hideLoading();
        Get.offAndToNamed(Routes.HOME);
      });
    }
  }

  void _writeStore(String url, String token) {
    _storage.settingsBox.put(SettingsModel(
        id: SettingId.urlSettingId, name: StorageKey.url, strValue: url));
    _storage.settingsBox.put(SettingsModel(
        id: SettingId.tokenSettingId, name: StorageKey.token, strValue: token));
  }

  void _clearStorage() {
    _storage.clearAll();
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

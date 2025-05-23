import 'dart:io';

import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:dolirest/config_dev.dart';

class LoginController extends GetxController {
  final StorageService storage = Get.find();
  final UserRepository userRepositoty = Get.find();
  var serverUrl = ''.obs;
  var apiKey = ''.obs;
  GlobalKey<FormState> serverFormKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController apiController = TextEditingController();
  @override
  void onInit() {
    if (kDebugMode) {
      urlController.text = ConfigDev.url;
      apiController.text = ConfigDev.apiKey;
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
      serverUrl('https://${urlController.text.trim()}');
      apiKey(apiController.text.trim());

      final result = await userRepositoty.login(
          url: serverUrl.value, apiKey: apiKey.value);
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackBarHelper.errorSnackbar(message: failure.message);
        _clearStorage();
      }, (user) async {
        _writeStore();
        storage.storeUser(user);
        DialogHelper.hideLoading();
        if (Platform.isAndroid) {
          Restart.restartApp();
        } else {
          Get.offAllNamed(Routes.HOME);
        }
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore() {
    storage.storeSetting(StorageKey.url, serverUrl.value);
    storage.storeSetting(StorageKey.apiKey, apiKey.value);
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

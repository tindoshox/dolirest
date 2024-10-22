import 'package:dolirest/infrastructure/dal/services/storage/storage.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';

class SettingsController extends GetxController {
  final StorageController storageController = Get.find();
  String serverUrl = '';
  String apiKey = '';
  GlobalKey<FormState> serverFormKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController apiController = TextEditingController();

  /// Validates the form and adds the server if the form is valid.
  Future validate() async {
    final FormState form = serverFormKey.currentState!;
    _writeStore();
    if (form.validate()) {
      DialogHelper.showLoading('Verifying Server Info...');

      await RemoteServices.fetchUserInfo().then((value) async {
        DialogHelper.hideLoading();
        if (!value.hasError) {
          storageController.storeSetting(
              StorageKey.user, value.data.login.toString());
          Get.offAndToNamed(Routes.HOME);
        } else {
          _clearStorage();

          SnackbarHelper.errorSnackbar(message: value.errorMessage);
        }
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore() async {
    storageController.storeSetting(StorageKey.url, urlController.text.trim());
    storageController.storeSetting(
        StorageKey.apiKey, apiController.text.trim());
  }

  void _clearStorage() async {
    storageController.clearSetting(StorageKey.url);
    storageController.clearSetting(StorageKey.apiKey);
  }

  void getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      apiController.text = clipboardText;
    }
  }
}

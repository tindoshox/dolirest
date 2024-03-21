import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class SettingsController extends GetxController {
  String serverUrl = '';
  String apiKey = '';
  GlobalKey<FormState> serverFormKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController apiController = TextEditingController();

  @override
  void onInit() {
    readSettings();
    super.onInit();
  }

  void readSettings() async {
    if (Storage.settings.get('url') != null) {
      serverUrl = Storage.settings.get('url');
      urlController.text = serverUrl;
    }

    if (Storage.settings.get('apikey') != null) {
      apiKey = Storage.settings.get('apikey');
      apiController.text = apiKey;
    }
  }

  /// Validates the form and adds the server if the form is valid.
  Future validate() async {
    final FormState form = serverFormKey.currentState!;
    _writeStore();
    if (form.validate()) {
      DialogHelper.showLoading('Verifying Server Info...');

      await RemoteServices.fetchUserInfo().then((value) async {
        DialogHelper.hideLoading();
        if (!value.hasError) {
          Storage.settings.put('user', value.data.login.toString());
          Get.offAndToNamed(Routes.HOME);
        } else {
          _clearStorage();

          SnackBarHelper.errorSnackbar(message: value.errorMessage);
        }
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore() async {
    Storage.settings.put('url', urlController.text.trim());
    Storage.settings.put('apikey', apiController.text.trim());
  }

  void _clearStorage() async {
    Storage.settings.clear();
  }

  void getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      apiController.text = clipboardText;
    }
  }
}

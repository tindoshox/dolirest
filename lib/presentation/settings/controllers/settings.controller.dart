import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class SettingsController extends GetxController {
  var serverUrl = '';
  var apiKey = '';
  final serverFormKey = GlobalKey<FormState>();
  final urlController = TextEditingController();
  final apiController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    readSettings();
    super.onInit();
  }

  void readSettings() {
    if (getBox.read('url') != null) {
      serverUrl = getBox.read('url');
      urlController.text = serverUrl;
    }

    if (getBox.read('apikey') != null) {
      apiKey = getBox.read('apikey');
      apiController.text = apiKey;
    }
  }

  /// Validates the form and adds the server if the form is valid.
  Future validate() async {
    final FormState form = serverFormKey.currentState!;
    _writeStore();
    if (form.validate()) {
      DialogHelper.showLoading('Verifying Server Info...');

      await RemoteServices.fetchUserInfo().then((value) {
        if (!value.hasError) {
          DialogHelper.hideLoading();
          Get.offAndToNamed(Routes.HOME);
        } else {
          _clearStorage();
          DialogHelper.hideLoading();
          SnackBarHelper.errorSnackbar(message: value.errorMessage);
        }
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore() {
    getBox.write('url', urlController.text.trim());
    getBox.write('apikey', apiController.text.trim());
    //Get.offAndToNamed(Routes.HOME);
  }

  void _clearStorage() {
    getBox.write('url', "");
    getBox.write('apikey', "");
  }

  void getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      apiController.text = clipboardText;
    }
  }
}

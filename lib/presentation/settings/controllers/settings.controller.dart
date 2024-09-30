import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';

class SettingsController extends GetxController {
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
          Storage.settings.put('connected', true);
          Storage.settings.put('user', value.data.login.toString());
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
    Storage.settings.put('url', urlController.text.trim());
    Storage.settings.put('apikey', apiController.text.trim());
  }

  void _clearStorage() async {
    Storage.settings.delete('url');
    Storage.settings.delete('apikey');
  }

  void getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      apiController.text = clipboardText;
    }
  }
}

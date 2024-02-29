import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class SettingsController extends GetxController {
  var serverUrl = '';
  var apiKey = '';
  final serverFormKey = GlobalKey<FormBuilderState>();
  final urlController = TextEditingController();
  final apiController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    readSettings();
    super.onInit();
  }

  void readSettings() {
    if (box.read('url') != null) {
      serverUrl = box.read('url');
      urlController.text = serverUrl;
    }

    if (box.read('apikey') != null) {
      apiKey = box.read('apikey');
      apiController.text = apiKey;
    }
  }

  /// Validates the form and adds the server if the form is valid.
  Future validate() async {
    final FormBuilderState form = serverFormKey.currentState!;
    _writeStore();
    if (form.validate()) {
      DialogHelper.showLoading('Verifying Server Info');

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
    box.write('url', urlController.text.trim());
    box.write('apikey', apiController.text.trim());
    //Get.offAndToNamed(Routes.HOME);
  }

  void _clearStorage() {
    box.write('url', "");
    box.write('apikey', "");
  }
}

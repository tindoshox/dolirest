import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final StorageController storage = Get.find();
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

      final result = await RemoteServices.login();
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackbarHelper.errorSnackbar(message: failure.message);
        _clearStorage();
      }, (user) async {
        storage.storeUser(user);

        DialogHelper.hideLoading();
        Get.offAndToNamed(Routes.HOME);
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore() async {
    storage.storeSetting(StorageKey.url, urlController.text.trim());
    storage.storeSetting(StorageKey.apiKey, apiController.text.trim());
  }

  void _clearStorage() async {
    storage.clearAll();
  }

  void getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;
    if (clipboardText != null) {
      apiController.text = clipboardText;
    }
  }
}

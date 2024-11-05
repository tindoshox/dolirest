import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/dio_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/user_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final StorageService storage = Get.find();
  final UserRepository userRepositoty = Get.find();
  final DioService dioService = Get.find();
  String serverUrl = '';
  String apiKey = '';
  GlobalKey<FormState> serverFormKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  TextEditingController apiController = TextEditingController();

  /// Validates the form and adds the server if the form is valid.
  Future validate() async {
    final FormState form = serverFormKey.currentState!;

    if (form.validate()) {
      _writeStore();
      DialogHelper.showLoading('Verifying Server Info...');

      final result = await userRepositoty.login(
          url: 'https://${urlController.text.trim()}',
          apiKey: apiController.text.trim());
      result.fold((failure) {
        DialogHelper.hideLoading();
        SnackbarHelper.errorSnackbar(message: failure.message);
        _clearStorage();
      }, (user) async {
        storage.storeUser(user);
        dioService.configureDio(
            url: 'https://${urlController.text.trim()}',
            apiKey: apiController.text.trim());
        DialogHelper.hideLoading();
        Get.offAndToNamed(Routes.HOME);
      });
    }
  }

  /// Writes the server info to the local storage.
  void _writeStore() {
    storage.storeSetting(
        StorageKey.url, 'https://${urlController.text.trim()}');
    storage.storeSetting(StorageKey.apiKey, apiController.text.trim());
  }

  void _clearStorage() {
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

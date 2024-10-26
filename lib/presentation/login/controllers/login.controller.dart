import 'package:dolirest/infrastructure/dal/models/company_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class LoginController extends GetxController {
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
              StorageKey.user,
              value.data.firstname != null
                  ? '${value.data.firstname.toString().capitalizeFirst} ${value.data.lastname.toString().capitalizeFirst}'
                  : '${value.data.login.toString().capitalizeFirst}');
          await _getCompany().then((value) {
            Get.offAndToNamed(Routes.HOME);
          });
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

  _getCompany() async {
    await RemoteServices.fetchCompany().then((value) {
      if (value.data != null) {
        CompanyModel companyModel = value.data;
        storageController.storeCompany(companyModel);
      }
    });
  }
}

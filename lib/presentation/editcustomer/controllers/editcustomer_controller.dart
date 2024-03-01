import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class EditcustomerController extends GetxController {
  final customerFormKey = GlobalKey<FormBuilderState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final townController = TextEditingController();
  final phoneController = TextEditingController();
  final faxController = TextEditingController();

  var isLoading = false.obs;

  var customerToEdit = ThirdPartyModel().obs;
  String customerId = Get.arguments['customerId'];

  var selectedGroup = GroupModel().obs;

  @override
  void onReady() {
    if (customerId.isNotEmpty) {
      _fetchCustomerById(customerId);
    }
    super.onReady();
  }

  Future<List<GroupModel>> fetchGroups(searchString) async {
    List<GroupModel> groups = List.empty();

    var response = await RemoteServices.fetchGroups('%$searchString%');
    if (!response.hasError) {
      groups = response.data;
    } else {
      groups = [];
    }

    return groups;
  }

  void validateAndSave() async {
    final FormBuilderState form = customerFormKey.currentState!;
    if (form.validate()) {
      var customer = ThirdPartyModel(
          client: 1,
          codeClient: 'auto',
          name: nameController.text,
          address: addressController.text,
          town: townController.text,
          phone: phoneController.text,
          fax: faxController.text,
          stateId: selectedGroup.value.id);

      if (customerId.isEmpty) {
        _createCustomer(jsonEncode(customer));
      } else {
        _updateCustomer(jsonEncode(customer), customerId);
      }
    }
  }

  Future _createCustomer(String body) async {
    DialogHelper.showLoading('Saving Customer.');

    await RemoteServices.createCustomer(body).then((value) {
      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      }
      nameController.text = '';
      addressController.text = '';
      townController.text = '';
      phoneController.text = '';
      faxController.text = '';
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'customerId': value.data});
    });
  }

  Future _fetchCustomerById(String id) async {
    DialogHelper.showLoading('Loading Customer');

    await RemoteServices.fetchThirdPartyById(id).then((value) {
      DialogHelper.hideLoading();

      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      }

      customerToEdit(value.data);
      nameController.text = customerToEdit.value.name;
      addressController.text = customerToEdit.value.address;
      townController.text = customerToEdit.value.town;
      phoneController.text = customerToEdit.value.phone ?? '';
      faxController.text = customerToEdit.value.fax ?? '';
    });
  }

  Future _updateCustomer(String body, String id) async {
    DialogHelper.showLoading('Updating Customer');
    await RemoteServices.updateCustomer(body, id).then((value) {
      DialogHelper.hideLoading();

      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      }

      SnackBarHelper.successSnackbar(
        message: 'Customer updated',
      );
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'customerId': customerId});
    });
  }
}

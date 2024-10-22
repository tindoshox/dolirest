import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class EditCustomerController extends GetxController {
  StorageController storageController = Get.find();
  GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController faxController = TextEditingController();

  RxBool isLoading = false.obs;

  Rx<CustomerModel> customerToEdit = CustomerModel().obs;
  String customerId = Get.arguments['customerId'];

  Rx<GroupModel> selectedGroup = GroupModel().obs;
  RxList<GroupModel> groups = List<GroupModel>.empty().obs;

  List<String> addresses = <String>[];
  List<String> towns = <String>[];

  @override
  void onInit() async {
    if (customerId.isNotEmpty) {
      await _fetchCustomerById(customerId);
    }

    List<GroupModel> list = storageController.getGroupList();

    if (list.length < 50) {
      await refreshGroups();
    } else {
      groups.value = list;
    }

    await getTownSuggestions();
    super.onInit();
  }

  @override
  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    townController.dispose();
    phoneController.dispose();
    faxController.dispose();
  }

  getTownSuggestions() {
    List<CustomerModel> customers =
        storageController.getCustomerList();

    towns =
        customers.map((customer) => customer.town.toString()).toSet().toList();
    towns.removeWhere((element) => element == "");
    towns.sort((a, b) => a.compareTo(b));
    //return towns;
  }

  getAddressSuggestions({String? town = ""}) {
    List<CustomerModel> customers =
        storageController.getCustomerList();
    if (town != null && town != "") {
      customers.removeWhere((element) => element.town != town.trim());
    }
    addresses = customers
        .map((customer) => customer.address.toString())
        .toSet()
        .toList();
    addresses.removeWhere((element) => element == "");

    addresses.sort((a, b) => a.compareTo(b));
  }

  getGroups({String search = ""}) {
    if (search.isNotEmpty) {
      groups.value = storageController
          .getGroupList()
          .where((group) => group.name.contains(search))
          .toList();
    } else {
      groups.value = storageController.getGroupList();
    }
    return groups;
  }

  refreshGroups() async {
    await RemoteServices.fetchGroups().then((value) {
      if (value.data != null) {
        final List<GroupModel> groups = value.data;
        for (GroupModel group in groups) {
          storageController.storeGroup(group.id, group);
        }
      }
    });
  }

  void validateAndSave() async {
    final FormState form = customerFormKey.currentState!;
    if (form.validate()) {
      var customer = CustomerModel(
              client: "1",
              codeClient: 'auto',
              name: nameController.text,
              address: addressController.text,
              town: townController.text,
              phone: phoneController.text,
              fax: faxController.text,
              stateId: selectedGroup.value.id)
          .toJson();
      customer.removeWhere((key, value) => value == null);

      if (customerId.isEmpty) {
        _createCustomer(jsonEncode(customer));
      } else {
        _updateCustomer(jsonEncode(customer), customerId);
      }
    }
  }

  Future _createCustomer(String body) async {
    DialogHelper.showLoading('Saving Customer...');

    await RemoteServices.createCustomer(body).then((value) async {
      DialogHelper.hideLoading();
      if (value.hasError) {
        SnackbarHelper.errorSnackbar(message: value.errorMessage);
      } else {
        await _fetchNewCustomer(value.data);
        Get.offAndToNamed(Routes.CUSTOMERDETAIL,
            arguments: {'customerId': value.data});
      }
    });
  }

  _fetchNewCustomer(data) async {
    await RemoteServices.fetchThirdPartyById(data).then((value) {
      if (value.statusCode == 200 && value.data != null) {
        final CustomerModel customer = value.data;
        storageController.storeCustomer(customer.id, customer);
      }
    });
  }

  Future _fetchCustomerById(String id) async {
    customerToEdit.value = storageController.getCustomer(id)!;
    nameController.text = customerToEdit.value.name!;
    addressController.text = customerToEdit.value.address ?? '';
    townController.text = customerToEdit.value.town ?? '';
    phoneController.text = customerToEdit.value.phone ?? '';
    faxController.text = customerToEdit.value.fax ?? '';
  }

  Future _updateCustomer(String body, String id) async {
    DialogHelper.showLoading('Updating Customer...');
    await RemoteServices.updateCustomer(body, id).then((value) async {
      DialogHelper.hideLoading();

      if (value.hasError) {
        SnackbarHelper.errorSnackbar(message: value.errorMessage);
      }

      SnackbarHelper.successSnackbar(
        message: 'Customer updated',
      );

      storageController.storeCustomer(customerId, value.data);

      Get.offAndToNamed(Routes.CUSTOMERDETAIL, arguments: {
        'customerId': customerId,
      });
    });
  }

  void clearGroup() {
    selectedGroup(GroupModel());
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class EditCustomerController extends GetxController {
  StorageController storage = Get.find();
  CustomerRepository customerRepository = Get.find();
  final GroupRepository groupRepository = Get.find();
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

  List<String> towns = <String>[];
  var addresses = List<AddressModel>.empty().obs;

  var selectedTown = ''.obs;

  @override
  void onInit() async {
    if (customerId.isNotEmpty) {
      await _fetchCustomerById(customerId);
    }
    addresses.value = storage.getAddressList();

    if (storage.getGroupList().isEmpty) {
      _refreshGroups();
    } else {
      groups.value = storage.getGroupList();
    }

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    townController.dispose();
    phoneController.dispose();
    faxController.dispose();
  }

  getGroups({String search = ""}) {
    if (search.isNotEmpty) {
      groups.value = storage
          .getGroupList()
          .where((group) => group.name.contains(search))
          .toList();
    } else {
      groups.value = storage.getGroupList();
    }
    return groups;
  }

  _refreshGroups() async {
    final result = await groupRepository.fetchGroups();
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (groups) {
      for (GroupModel group in groups) {
        storage.storeGroup(group.id, group);
      }
    });
  }

  void validateAndSave() async {
    final FormState form = customerFormKey.currentState!;
    if (form.validate()) {
      var customer = CustomerModel(
              client: "1",
              codeClient: 'auto',
              name: nameController.text.toUpperCase(),
              address: addressController.text.toUpperCase(),
              town: townController.text.toUpperCase(),
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

    final result = await customerRepository.createCustomer(body);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackbarHelper.errorSnackbar(message: failure.message);
    }, (id) {
      DialogHelper.hideLoading();
      _fetchNewCustomer(id);
      Get.offAndToNamed(Routes.CUSTOMERDETAIL, arguments: {'customerId': id});
    });
  }

  _fetchNewCustomer(id) async {
    final result = await customerRepository.fetchCustomerById(id);

    result.fold((failure) {
      SnackbarHelper.errorSnackbar(message: failure.message);
      log('Fetch new customer: ${failure.message}');
    }, (customer) => storage.storeCustomer(customer.id, customer));
  }

  Future _fetchCustomerById(String id) async {
    customerToEdit.value = storage.getCustomer(id)!;
    nameController.text = customerToEdit.value.name!;
    addressController.text = customerToEdit.value.address ?? '';
    townController.text = customerToEdit.value.town ?? '';
    phoneController.text = customerToEdit.value.phone ?? '';
    faxController.text = customerToEdit.value.fax ?? '';
  }

  Future _updateCustomer(String body, String id) async {
    DialogHelper.showLoading('Updating Customer...');
    final result = await customerRepository.updateCustomer(body, id);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackbarHelper.errorSnackbar(message: failure.message);
    }, (customer) {
      storage.storeCustomer(customer.id, customer);
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL, arguments: {
        'customerId': customerId,
      });
    });
  }

  void clearGroup() {
    selectedGroup(GroupModel());
  }
}

import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/group_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditcustomerController extends GetxController {
  final customerFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final townController = TextEditingController();
  final phoneController = TextEditingController();
  final faxController = TextEditingController();

  var isLoading = false.obs;

  var customerToEdit = ThirdPartyModel().obs;
  String customerId = Get.arguments['customerId'];

  var selectedGroup = GroupModel().obs;
  var groups = List<GroupModel>.empty().obs;

  var addresses = <String>[];
  var towns = <String>[];

  @override
  void onInit() async {
    if (customerId.isNotEmpty) {
      await _fetchCustomerById(customerId);
    }

    var box = await Hive.openBox<GroupModel>('groups');
    var list = box.toMap().values.toList();

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

  getTownSuggestions() async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    List<ThirdPartyModel> customers = box.toMap().values.toList();

    towns =
        customers.map((customer) => customer.town.toString()).toSet().toList();
    towns.removeWhere((element) => element == "");
    towns.sort((a, b) => a.compareTo(b));
    //return towns;
  }

  getAddressSuggestions({String? town = ""}) async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    List<ThirdPartyModel> customers = box.toMap().values.toList();
    if (town != null && town != "") {
      customers.removeWhere((element) => element.town != town);
    }
    addresses = customers
        .map((customer) => customer.address.toString())
        .toSet()
        .toList();
    addresses.removeWhere((element) => element == "");

    addresses.sort((a, b) => a.compareTo(b));
    //return addresses;
  }

  Future getGroups({String search = ""}) async {
    var box = await Hive.openBox<GroupModel>('groups');

    if (search.isNotEmpty) {
      groups.value = box
          .toMap()
          .values
          .toList()
          .where((group) => group.name.contains(search))
          .toList();
    } else {
      groups.value = box.toMap().values.toList();
    }
    return groups;
  }

  Future<List<GroupModel>> refreshGroups() async {
    var box = await Hive.openBox<GroupModel>('groups');
    await RemoteServices.fetchGroups().then((value) async {
      if (!value.hasError) {
        for (GroupModel group in value.data) {
          box.put(group.id, group);
        }
      }
    });

    return groups;
  }

  void validateAndSave() async {
    final FormState form = customerFormKey.currentState!;
    if (form.validate()) {
      var customer = ThirdPartyModel(
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
    DialogHelper.showLoading('Saving Customer.');

    await RemoteServices.createCustomer(body).then((value) async {
      DialogHelper.hideLoading();
      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      } else {
        await _fetchNewCustomer(value.data);
        Get.offAndToNamed(Routes.CUSTOMERDETAIL,
            arguments: {'customerId': value.data});
      }
    });
  }

  _fetchNewCustomer(data) async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');
    await RemoteServices.fetchThirdPartyById(data).then((value) {
      if (!value.hasError) {
        box.put(data, value.data);
      }
    });
  }

  Future _fetchCustomerById(String id) async {
    var box = await Hive.openBox<ThirdPartyModel>('customers');

    customerToEdit.value = box.get(id)!;
    nameController.text = customerToEdit.value.name!;
    addressController.text = customerToEdit.value.address ?? '';
    townController.text = customerToEdit.value.town ?? '';
    phoneController.text = customerToEdit.value.phone ?? '';
    faxController.text = customerToEdit.value.fax ?? '';
  }

  Future _updateCustomer(String body, String id) async {
    DialogHelper.showLoading('Updating Customer');
    await RemoteServices.updateCustomer(body, id).then((value) async {
      DialogHelper.hideLoading();

      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      }

      SnackBarHelper.successSnackbar(
        message: 'Customer updated',
      );

      var box = await Hive.openBox<ThirdPartyModel>('customers');
      box.put(customerId, value.data);

      Get.offAndToNamed(Routes.CUSTOMERDETAIL, arguments: {
        'customerId': customerId,
      });
    });
  }
}

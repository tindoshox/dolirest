import 'dart:async';
import 'dart:convert';

import 'package:dolirest/infrastructure/dal/models/address_model.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/group/group_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_service.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/group_repository.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/objectbox.g.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditCustomerController extends GetxController {
  final StorageService _storage = Get.find();
  final NetworkService _network = Get.find();
  final CustomerRepository _customerRepository = Get.find();
  final GroupRepository groupRepository = Get.find();
  GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController townController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController faxController = TextEditingController();

  var isLoading = false.obs;
  var connected = false.obs;

  var customerToEdit = CustomerEntity().obs;
  int? entityId = Get.arguments['entityId'];

  var selectedGroup = GroupEntity().obs;
  var groups = List<GroupEntity>.empty().obs;

  var towns = <String>[];
  var addresses = List<AddressModel>.empty().obs;

  final selectedTown = ''.obs;
  StreamSubscription? _addressSub;
  final addressList = <String>[].obs;

  @override
  void onInit() async {
    if (entityId != null) {
      customerToEdit.value = _storage.customerBox.get(entityId!)!;
    }

    ever(_network.connected, (_) {
      connected = _network.connected;
    });

    connected = _network.connected;
    if (entityId != null) {
      await _fetchCustomerById(entityId!);
    }

    if (_storage.groupBox.getAll().isEmpty) {
      _refreshGroups();
    } else {
      groups.value = _storage.groupBox.getAll();
    }
    // Watch for changes to selectedTown and rebind query
    ever(selectedTown, (_) => bindAddressStream());

    // Initial bind
    bindAddressStream();
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

  void bindAddressStream() {
    _addressSub?.cancel(); // cleanup old sub
    _addressSub = _storage.addressBox
        .query(AddressModel_.town.equals(selectedTown.value))
        .watch(triggerImmediately: true)
        .map((q) =>
            q.find().map((a) => a.address.toUpperCase()).toSet().toList()
              ..sort())
        .listen((data) {
      addressList.assignAll(data);
    });
  }

  RxList<GroupEntity> getGroups({String search = ""}) {
    if (search.isNotEmpty) {
      groups.value = _storage.groupBox
          .getAll()
          .where((group) => group.name!.contains(search))
          .toList();
    } else {
      groups.value = _storage.groupBox.getAll();
    }
    return groups;
  }

  Future<void> _refreshGroups() async {
    final result = await groupRepository.fetchGroups();
    result.fold(
        (failure) => SnackBarHelper.errorSnackbar(message: failure.message),
        (groups) {
      for (GroupEntity group in groups) {
        _storage.groupBox.put(group);
      }
    });
  }

  void validateAndSave() async {
    DialogHelper.showLoading('Validating inputs ...');
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
        stateId: selectedGroup.value.groupId,
      ).toJson();
      customer.removeWhere((key, value) => value == null);

      if (entityId == null) {
        DialogHelper.updateMessage('Creating customer ...');
        _createCustomer(jsonEncode(customer));
      } else {
        DialogHelper.updateMessage('Updating customer ...');
        _updateCustomer(jsonEncode(customer), customerToEdit.value.customerId);
      }
    }
  }

  Future _createCustomer(String body) async {
    final result = await _customerRepository.createCustomer(body);
    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (id) {
      DialogHelper.hideLoading();
      _fetchNewCustomer(id).then((newId) => Get.offAndToNamed(
          Routes.CUSTOMERDETAIL,
          arguments: {'entityId': newId}));
    });
  }

  Future<int> _fetchNewCustomer(String id) async {
    final result = await _customerRepository.fetchCustomerById(id);

    result.fold((failure) {
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (customer) {
      _storage.customerBox.put(customer);
    });
    return _storage.customerBox
        .query(CustomerEntity_.customerId.equals(id))
        .build()
        .findFirst()!
        .id;
  }

  Future _fetchCustomerById(int id) async {
    customerToEdit.value = _storage.customerBox.get(id)!;
    nameController.text = customerToEdit.value.name;
    addressController.text = customerToEdit.value.address;
    townController.text = customerToEdit.value.town;
    phoneController.text = customerToEdit.value.phone;
    faxController.text = customerToEdit.value.fax;
  }

  Future _updateCustomer(String body, String id) async {
    final result = await _customerRepository.updateCustomer(body, id);

    result.fold((failure) {
      DialogHelper.hideLoading();
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (customer) async {
      _storage.storeCustomer(customer);
      DialogHelper.hideLoading();
      Get.offAndToNamed(Routes.CUSTOMERDETAIL,
          arguments: {'entityId': customer.id});
      SnackBarHelper.successSnackbar(message: 'Customer updated successfully');
    });
  }

  void clearGroup() {
    selectedGroup(GroupEntity());
  }

  List<String> loadTowns() {
    return _storage.addressBox
        .getAll()
        .map((a) => a.town.toUpperCase())
        .toSet()
        .toList()
      ..sort();
  }
}

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';

class CustomerListController extends GetxController {
  var isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  StorageController storageController = Get.find();
  var searchIconVisible = true.obs;

  var searchString = ''.obs;

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  search({String searchText = ""}) {
    searchString.value = searchText;
  }

  refreshCusomerList() async {
    isLoading(true);
    await RemoteServices.fetchThirdPartyList().then((value) {
      if (value.statusCode == 200 && value.data != null) {
        List<CustomerModel> customers = value.data;
        for (CustomerModel customer in customers) {
          storageController.storeCustomer(customer.id, customer);
        }
      }
      isLoading(false);
    });
  }
}

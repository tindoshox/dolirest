import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class CustomerListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxBool searchIconVisible = true.obs;

  int pageNumber = 0;
  RxString searchString = ''.obs;

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  search({String searchText = ""}) {
    searchString.value = searchText;
  }

  getAllCustomers() async {
    isLoading(true);

    await RemoteServices.fetchThirdPartyList().then((value) {
      isLoading(false);
      if (!value.hasError) {
        for (CustomerModel customer in value.data) {
          Storage.customers.put(customer.id, customer);
        }

        SnackBarHelper.successSnackbar(message: 'Customer data refreshed');
      } else {
        SnackBarHelper.errorSnackbar(
            message: 'Could not refresh customer data');
      }
    });
  }
}

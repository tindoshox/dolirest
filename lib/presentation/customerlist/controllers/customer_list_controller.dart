import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/dal/models/address_model.dart';
import '../../../utils/snackbar_helper.dart';

class CustomerListController extends GetxController {
  var isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  StorageController storage = Get.find();
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

  refreshCustomerList() async {
    isLoading(true);
    final result = await RemoteServices.fetchThirdPartyList();

    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (customers) {
      for (CustomerModel customer in customers) {
        storage.storeCustomer(customer.id, customer);
        if (customer.address != null && customer.town != null) {
          storage.storeAddresses(
            '${customer.town}-${customer.address}',
            AddressModel(
              town: customer.town,
              address: customer.address,
            ),
          );
        }
      }
    });
  }
}

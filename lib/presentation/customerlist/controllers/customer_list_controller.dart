import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerlistController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var isLastPage = false;

  final searchController = TextEditingController();
  final scrollController = ScrollController();
  var searchIcon = true.obs;

  int pageNumber = 0;
  var searchString = ''.obs;

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

    await RemoteServices.fetchThirdPartyList().then((value) async {
      isLoading(false);
      if (!value.hasError) {
        var box = await Hive.openBox<ThirdPartyModel>(BoxName.customers.name);
        for (ThirdPartyModel customer in value.data) {
          box.put(customer.id, customer);
        }

        SnackBarHelper.successSnackbar(message: 'Customer data refreshed');
      } else {
        SnackBarHelper.errorSnackbar(
            message: 'Could not refresh customer data');
      }
    });
  }
}

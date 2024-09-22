import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';

class CustomerListController extends GetxController {
  var isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
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
      isLoading(false);
    });
  }
}

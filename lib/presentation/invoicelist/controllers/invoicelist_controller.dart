import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoicelistController extends GetxController {
  final StorageController storage = Get.find<StorageController>();
  var isLoading = false.obs;

  bool isLastPage = false;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var searchString = ''.obs;
  var searchIcon = true.obs;

  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  search({String searchText = ""}) {
    searchString.value = searchText;
  }

  refreshInvoiceList() async {
    isLoading(true);

    await RemoteServices.fetchInvoiceList(status: "unpaid").then((value) async {
      isLoading(false);
    });
  }

  toggleSearch() {
    if (searchController.text.isEmpty) {
      searchIcon.value = !searchIcon.value;
    }
    if (!searchIcon.value) {
      searchController.clear();
      searchString.value = "";
    }
  }
}

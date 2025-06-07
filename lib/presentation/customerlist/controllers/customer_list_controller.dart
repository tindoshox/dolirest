import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerListController extends GetxController {
  bool noInvoiceCustomers = Get.arguments['noInvoiceCustomers'] ?? false;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  StorageService storage = Get.find();

  CustomerRepository repository = Get.find();
  final DataRefreshService dataRefreshContoller = Get.find();
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
    DialogHelper.showLoading('Syncing customers');
    if (!dataRefreshContoller.refreshing.value) {
      await dataRefreshContoller
          .syncCustomers()
          .then((v) => DialogHelper.hideLoading());
    } else {
      SnackBarHelper.errorSnackbar(message: 'Data refresh already running');
    }
  }
}

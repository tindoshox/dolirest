import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_contoller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage_service.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/utils/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerListController extends GetxController {
  bool noInvoiceCustomers = Get.arguments['noInvoiceCustomers'] ?? false;

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  StorageService storage = Get.find();
  CustomerRepository repository = Get.find();
  final DataRefreshContoller _dataRefreshContoller = Get.find();
  var searchIconVisible = true.obs;
  var searchString = ''.obs;

  var customers = <CustomerModel>[].obs;

  @override
  void onInit() {
    _watchBoxes();
    _updateCustomers();
    super.onInit();
  }

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
    await _dataRefreshContoller.syncCustomers();
    DialogHelper.hideLoading();
  }

  void _watchBoxes() {
    storage.invoicesListenable().addListener(_updateCustomers);
  }

  void _updateCustomers() {
    final list = storage.getCustomerList();
    var nic = <CustomerModel>[];
    if (noInvoiceCustomers) {
      for (var customer in list) {
        var invoices = storage
            .getInvoiceList()
            .where((invoice) => invoice.socid == customer.id)
            .toList();
        if (invoices.isEmpty) {
          nic.add(customer);
        }
      }
      nic.sort((a, b) => a.name.compareTo(b.name));
      customers.value = nic;
    } else {
      list.sort((a, b) => a.name.compareTo(b.name));
      customers.value = list;
    }
  }
}

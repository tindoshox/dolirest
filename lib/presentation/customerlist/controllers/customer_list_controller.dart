import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/data_refresh_service.dart';
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
  final StorageService _storage = Get.find();

  final CustomerRepository _customerRepository = Get.find();
  final DataRefreshService _data = Get.find();
  var customers = <CustomerEntity>[].obs;
  var invoices = <InvoiceEntity>[].obs;
  var searchIconVisible = true.obs;
  var searchString = ''.obs;

  @override
  void onInit() {
    everAll([_data.customers, _data.invoices], (_) {
      customers = _data.customers;
      invoices = _data.invoices;
    });
    customers = _data.customers;
    invoices = _data.invoices;

    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void search({String searchText = ""}) {
    searchString.value = searchText;
  }

  Future<void> refreshCustomerList() async {
    SnackBarHelper.successSnackbar(message: 'Refreshing customers');

    await _data.syncCustomers();
  }

  Future<void> deleteCustomer(String customerId, int entityId) async {
    DialogHelper.showLoading('Deleting customer...');
    final result = await _customerRepository.deleteCustomer(customerId);
    result.fold(
      (failure) {
        DialogHelper.hideLoading();
        if (failure.code == 404) {
          _storage.customerBox.remove(entityId);

          SnackBarHelper.successSnackbar(
              message: 'Customer deleted', duration: Duration(seconds: 1));
        } else {
          SnackBarHelper.errorSnackbar(message: failure.message);
        }
      },
      (res) {
        DialogHelper.hideLoading();
        _storage.customerBox.remove(entityId);

        SnackBarHelper.successSnackbar(message: 'Customer deleted');
      },
    );
  }
}

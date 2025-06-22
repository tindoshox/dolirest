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
  final StorageService storage = Get.find();

  final CustomerRepository customerRepository = Get.find();
  final DataRefreshService data = Get.find();
  var customers = <CustomerEntity>[].obs;
  var invoices = <InvoiceEntity>[].obs;
  var searchIconVisible = true.obs;
  var searchString = ''.obs;

  @override
  void onInit() {
    everAll([data.customers, data.invoices], (_) {
      customers = data.customers;
      invoices = data.invoices;
    });
    customers = data.customers;
    invoices = data.invoices;

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
    SnackBarHelper.successSnackbar(message: 'Refreshing customers');

    await data.syncCustomers();
  }

  Future<void> deleteCustomer(String customerId, int entityId) async {
    DialogHelper.showLoading('Deleting customer...');
    final result = await customerRepository.deleteCustomer(customerId);
    result.fold(
      (failure) {
        DialogHelper.hideLoading();
        if (failure.code == 404) {
          storage.customerBox.remove(entityId);

          SnackBarHelper.successSnackbar(message: 'Customer deleted');
        } else {
          SnackBarHelper.errorSnackbar(message: failure.message);
        }
      },
      (res) {
        DialogHelper.hideLoading();
        storage.customerBox.remove(entityId);

        SnackBarHelper.successSnackbar(message: 'Customer deleted');
      },
    );
  }
}

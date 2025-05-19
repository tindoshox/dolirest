import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../infrastructure/dal/models/address_model.dart';
import '../../../utils/snackbar_helper.dart';

class CustomerListController extends GetxController {
  bool noInvoiceCustomers = Get.arguments['noInvoiceCustomers'] ?? false;
  var isLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  StorageService storage = Get.find();
  CustomerRepository repository = Get.find();
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
    isLoading(true);
    final result = await repository.fetchCustomerList();

    result.fold((failure) {
      isLoading(false);
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (customers) {
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
      final apiIds = customers.map((customer) => customer.id).toSet();
      List<CustomerModel> localCustomers = storage.getCustomerList();
      final keysToDelete = <dynamic>[];
      for (var localCustomer in localCustomers) {
        if (!apiIds.contains(localCustomer.id)) {
          keysToDelete.add(localCustomer.id);
        }
      }

      storage.deleteAllCustomer(keysToDelete);
      isLoading(false);
    });
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

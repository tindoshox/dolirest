import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  StorageController storage = Get.find();
  final String customerId = Get.arguments['customerId'];
  final List<Tab> customerTabs = [
    const Tab(text: 'Details'),
    const Tab(text: 'Invoices')
  ];
  RxInt tabIndex = 0.obs;
  late TabController tabController;

  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    tabController = TabController(length: customerTabs.length, vsync: this);
    await _fetchInvoices();
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  _fetchInvoices() async {
    isLoading(true);

    if (storage.getCustomer(customerId) == null) {
      await _refreshInvoiceData();
    }

    isLoading(false);
  }

  // Fetch invoice data from server
  Future _refreshInvoiceData() async {
    final result =
        await RemoteServices.fetchInvoiceList(customerId: customerId);
    result.fold(
        (failure) => SnackbarHelper.errorSnackbar(message: failure.message),
        (invoices) {
      for (InvoiceModel invoice in invoices) {
        storage.storeInvoice(invoice.id, invoice);
      }
    });
  }
}

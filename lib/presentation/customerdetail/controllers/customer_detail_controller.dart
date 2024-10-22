import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
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

    if (Storage.invoices.get(customerId) == null) {
      await _refreshInvoiceData();
    }

    isLoading(false);
  }

  // Fetch invoice data from server
  Future _refreshInvoiceData() async {
    await RemoteServices.fetchInvoiceList(customerId: customerId);
  }
}

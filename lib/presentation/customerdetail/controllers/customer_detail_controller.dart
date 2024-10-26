import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  StorageController storageController = Get.find();
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

    if (storageController.getCustomer(customerId) == null) {
      await _refreshInvoiceData();
    }

    isLoading(false);
  }

  // Fetch invoice data from server
  Future _refreshInvoiceData() async {
    await RemoteServices.fetchInvoiceList(customerId: customerId).then((value) {
      if (value.data != null) {
        final List<InvoiceModel> invoices = value.data;
        for (InvoiceModel invoice in invoices) {
          storageController.storeInvoice(invoice.id, invoice);
        }
      }
    });
  }
}

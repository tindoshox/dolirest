import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageService storage = Get.find();
  final InvoiceRepository repository = Get.find();
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

    if (storage.getCustomer(customerId) == null ||
        storage.getInvoiceList(customerId: customerId).isEmpty) {
      await refreshInvoiceData();
    }

    isLoading(false);
  }

  // Fetch invoice data from server
  Future refreshInvoiceData({String? customerId}) async {
    final result = await repository.fetchInvoiceList(customerId: customerId);
    result.fold((failure) => null, (invoices) {
      for (InvoiceModel invoice in invoices) {
        storage.storeInvoice(invoice.id, invoice);
      }
    });
  }
}

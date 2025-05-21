import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/customer_repository.dart';
import 'package:dolirest/infrastructure/dal/services/remote_storage/repository/invoice_repository.dart';
import 'package:dolirest/utils/loading_overlay.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final StorageService storage = Get.find();
  final InvoiceRepository invoiceRepository = Get.find();
  final CustomerRepository customerRepository = Get.find();
  final String customerId = Get.arguments['customerId'];
  var customer = CustomerModel().obs;
  var invoices = <InvoiceModel>[].obs;

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
    _watchBoxes();
    _updateCustomer();
    _updateInvoices();
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    super.onInit();
  }

  @override
  void onReady() {
    if (invoices.isEmpty) {
      refreshCustomerInvoiceData();
    }
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  void _watchBoxes() {
    storage.customersListenable().addListener(_updateCustomer);
    storage.invoicesListenable().addListener(_updateInvoices);
  }

  void _updateCustomer() {
    final c = storage.getCustomer(customerId);
    if (c != null) {
      customer.value = c;
    }
  }

  void _updateInvoices() {
    invoices.value = storage.getInvoiceList(customerId: customerId);
  }

  // Fetch invoice data from server
  Future<void> refreshCustomerInvoiceData() async {
    isLoading.value = true;
    final result =
        await invoiceRepository.fetchInvoiceList(customerId: customerId);

    result.fold((failure) {
      isLoading.value = false;
      SnackBarHelper.errorSnackbar(message: failure.message);
    }, (invoices) {
      for (InvoiceModel invoice in invoices) {
        final customer = storage.getCustomer(invoice.socid);
        invoice.name = customer!.name;
        storage.storeInvoice(invoice.id, invoice);
      }
      isLoading.value = false;
    });
  }

  Future<void> deleteCustomer() async {
    DialogHelper.showLoading('Deleting customer...');
    final result = await customerRepository.deleteCustomer(customerId);
    result.fold(
      (failure) {
        if (!kReleaseMode) {
          debugPrint(failure.message);
        }
        DialogHelper.hideLoading();
        if (failure.code == 404) {
          storage.deleteCustomer(customerId);
          Get.back();
          SnackBarHelper.successSnackbar(message: 'Customer deleted');
        } else {
          SnackBarHelper.errorSnackbar(message: failure.message);
        }
      },
      (res) {
        DialogHelper.hideLoading();
        storage.deleteCustomer(customerId);
        Get.back();
        SnackBarHelper.successSnackbar(message: 'Customer deleted');
      },
    );
  }
}

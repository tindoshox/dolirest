import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerdetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String _customerId = Get.arguments['customerId'];
  final bool _refreshCustomer = Get.arguments['refresh'];
  final List<Tab> customerTabs =
      [const Tab(text: 'Details'), const Tab(text: 'Invoices')].obs;
  var tabIndex = 0.obs;
  late TabController tabController;

  var invoices = <InvoiceModel>[].obs;
  var customer = ThirdPartyModel().obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: customerTabs.length, vsync: this);

    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    _fetchData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  void _fetchData() async {
    isLoading(true);

    if (!_refreshCustomer) {
      //Customer data is fetched from storage.
      var box = await Hive.openBox<ThirdPartyModel>('customers');
      customer.value = box.get(_customerId)!;
    } else {
      //If refresh is required then data is fetched from server
      await _refreshCustomerData();
    }

    //Fetch invoice data
    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    //Invoice data is fetched from storage
    if (invoiceBox.get(_customerId) != null) {
      invoices.value = invoiceBox
          .toMap()
          .values
          .toList()
          .where((inv) => inv.socid == _customerId)
          .toList();
    } else {
      // If data not found in storage fetch from server
      await _refreshInvoiceData();
    }

    isLoading(false);
  }

  pullToRefresh() async {
    isLoading(true);
    await _refreshCustomerData();
    await _refreshInvoiceData();
    isLoading(false);
  }

  // Fetch customer data from server
  Future _refreshCustomerData() async {
    var customerBox = await Hive.openBox<ThirdPartyModel>('customers');
    await RemoteServices.fetchThirdPartyById(_customerId).then((value) {
      if (!value.hasError) {
        ThirdPartyModel newCustomer = value.data;
        customerBox.put(newCustomer.id, newCustomer);
        customer.value = customerBox.get(_customerId)!;
      } else {
        SnackBarHelper.errorSnackbar(
            message: '${value.errorMessage}: Failed to refresh customer data');
      }
    });
  }

  // Fetch invoice datad from server
  Future _refreshInvoiceData() async {
    var box = await Hive.openBox<InvoiceModel>('invoices');
    await RemoteServices.fetchInvoicesByCustomerId(_customerId).then((value) {
      if (!value.hasError) {
        for (var invoice in value.data) {
          box.put(invoice.id, invoice);
        }
      } else {
        SnackBarHelper.errorSnackbar(
            message: '${value.errorMessage}: Failed to refresh invoice data');
        invoices.value = List.empty();
      }
    });
  }
}

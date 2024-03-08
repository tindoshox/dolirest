import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerdetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String customerId = Get.arguments['customerId'];
  bool refreshCustomer = Get.arguments['refresh'];
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

    if (refreshCustomer) {
      await refreshCustomerData();
    } else {
      var box = await Hive.openBox<ThirdPartyModel>('customers');
      customer.value = box.get(customerId)!;
    }

    var invoiceBox = await Hive.openBox<InvoiceModel>('invoices');
    if (invoiceBox.get(customerId) == null) {
      await _refreshInvoiceData();
    }
    invoices.value = invoiceBox
        .toMap()
        .values
        .toList()
        .where((inv) => inv.socid == customerId)
        .toList();

    isLoading(false);
  }

  refreshCustomerData() async {
    var customerBox = await Hive.openBox<ThirdPartyModel>('customers');
    await RemoteServices.fetchThirdPartyById(customerId).then((value) {
      ThirdPartyModel newCustomer = value.data;
      customerBox.put(newCustomer.id, newCustomer);
      customer.value = customerBox.get(customerId)!;
    });
  }

  Future _refreshInvoiceData() async {
    var box = await Hive.openBox<InvoiceModel>('invoices');
    await RemoteServices.fetchInvoicesByCustomerId(customerId).then((value) {
      for (var invoice in value.data) {
        box.put(invoice.id, invoice);
      }
    });
  }
}

import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerdetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String customerId = Get.arguments['customerId'];
  final List<Tab> customerTabs =
      [const Tab(text: 'Details'), const Tab(text: 'Invoices')].obs;
  var tabIndex = 0.obs;
  late TabController tabController;

  var isLoading = false.obs;

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

    //Fetch invoice data
    var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);
    //Invoice data is fetched from storage
    if (box.get(customerId) == null) {
      await _refreshInvoiceData();
    }

    isLoading(false);
  }

  // Fetch invoice data from server
  Future _refreshInvoiceData() async {
    var box = await Hive.openBox<InvoiceModel>(BoxName.invoices.name);

    await RemoteServices.fetchInvoiceList(customerId: customerId)
        .then((value) async {
      if (!value.hasError) {
        for (var invoice in value.data) {
          box.put(invoice.id, invoice);
        }
      } else {
        SnackBarHelper.errorSnackbar(
            message: '${value.errorMessage}: Failed to refresh invoice data');
      }
    });
  }
}

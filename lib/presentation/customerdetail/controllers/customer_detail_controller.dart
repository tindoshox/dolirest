import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/services/remote_services.dart';
import 'package:dolirest/utils/snackbar_helper.dart';

class CustomerdetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  String customerId = Get.arguments['customerId'];
  //
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

    _fetchData(customerId);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
  }

  void _fetchData(String id) async {
    isLoading(true);

    await _fetchCustomerById(id);
    await _fetchCustomerInvoices(id);

    isLoading(false);
  }

  Future _fetchCustomerById(String id) async {
    await RemoteServices.fetchThirdPartyById(id).then((value) {
      if (value.hasError) {
        SnackBarHelper.errorSnackbar(message: value.errorMessage);
      }

      customer(value.data);
    });

    isLoading(false);
  }

  Future _fetchCustomerInvoices(String id) async {
    await RemoteServices.fetchInvoicesByCustomerId(id).then((value) {
      if (!value.hasError) {
        invoices(value.data);
      }
    });
  }
}

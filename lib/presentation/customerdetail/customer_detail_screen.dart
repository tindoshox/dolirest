import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_info_widget.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_invoice_list_widget.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';

class CustomerDetailScreen extends GetView<CustomerdetailController> {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var invoices = controller.invoices;
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        CustomActionButton(
            buttonText: 'Edit',
            onTap: () {
              bool connected = getBox.read('connected');
              if (connected) {
                Get.offAndToNamed(Routes.EDITCUSTOMER,
                    arguments: {'customerId': controller.customer.value.id});
              }
            }),
        CustomActionButton(
            buttonText: 'New Invoice',
            onTap: () {
              bool connected = getBox.read('connected');
              if (connected) {
                Get.offAndToNamed(Routes.CREATEINVOICE, arguments: {
                  'customerId': controller.customer.value.id,
                  'fromhome': false
                });
              }
            }),
      ],
      appBar: AppBar(
        title: const Text('Customer Details'),
        bottom: TabBar(
            controller: controller.tabController,
            tabs: controller.customerTabs),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(controller: controller.tabController, children: [
              CustomerInfo(customer: controller.customer.value),
              InvoiceListWidget(invoices: invoices),
            ])),
    );
  }
}

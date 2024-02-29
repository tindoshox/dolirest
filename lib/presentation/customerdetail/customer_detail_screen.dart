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

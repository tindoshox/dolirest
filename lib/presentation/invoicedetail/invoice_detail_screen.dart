import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/invoicedetail/components/invoice_detail_widget.dart';
import 'package:dolirest/presentation/invoicedetail/components/payment_data_table.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';

import 'controllers/invoice_detail_controller.dart';

class InvoicedetailScreen extends GetView<InvoiceDetailController> {
  const InvoicedetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomActionButton(
              buttonText: 'Payment',
              onTap: controller.invoice.value.remaintopay == '0'
                  ? null
                  : () => Get.offAndToNamed(
                        Routes.PAYMENT,
                        arguments: {
                          'invid': controller.invoice.value.id,
                          'socid': controller.invoice.value.socid,
                          'fromhome': false
                        },
                      ),
            ),
            CustomActionButton(
              buttonText: 'Download',
              onTap: () => controller.generateDocument(),
            ),
          ],
        ),
      ],
      appBar: AppBar(
        title: const Text('Invoice Detail'),
        centerTitle: true,
        bottom: TabBar(
            controller: controller.tabController, tabs: controller.invoiceTabs),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: controller.tabController,
                children: [
                  InvoiceDetailWidget(
                      onPressed: () => controller.setDueDate(),
                      customer: controller.customer.value,
                      invoice: controller.invoice.value),
                  ListView(
                    children: [
                      PaymentsDataTable(
                          payments: controller.payments,
                          invoice: controller.invoice.value)
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

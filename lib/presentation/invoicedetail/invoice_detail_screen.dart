import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/get_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/invoicedetail/components/invoice_detail_widget.dart';
import 'package:dolirest/presentation/invoicedetail/components/payment_data_table.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
            ValueListenableBuilder(
              valueListenable: Hive.box<InvoiceModel>('invoices')
                  .listenable(keys: [controller.customerId]),
              builder: (context, invoice, child) => CustomActionButton(
                  buttonText: 'Payment',
                  onTap: invoice.get(controller.invoiceId)!.remaintopay == '0'
                      ? null
                      : () {
                          bool connected = getBox.read('connected');
                          if (connected) {
                            Get.offAndToNamed(
                              Routes.PAYMENT,
                              arguments: {
                                'invid': controller.invoiceId,
                                'socid': controller.customerId,
                                'fromhome': false
                              },
                            );
                          }
                        }),
            ),
            CustomActionButton(
                buttonText: 'Download',
                onTap: () {
                  bool connected = getBox.read('connected');
                  if (connected) {
                    controller.generateDocument();
                  }
                } //=> ,
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
                  ValueListenableBuilder(
                    valueListenable: Hive.box<InvoiceModel>('invoices')
                        .listenable(keys: [controller.invoiceId]),
                    builder: (context, invoices, child) => InvoiceDetailWidget(
                        onPressed: () {
                          bool connected = getBox.read('connected');
                          if (connected) {
                            controller.setDueDate();
                          }
                        },
                        customer: controller.customer.value,
                        invoice: invoices.get(controller.invoiceId)!),
                  ),
                  Scrollbar(
                    child: ListView(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: Hive.box<InvoiceModel>('invoices')
                              .listenable(keys: [controller.customerId]),
                          builder: (context, invoices, child) =>
                              PaymentsDataTable(
                            invoiceId: controller.invoiceId,
                            totalTtc:
                                invoices.get(controller.invoiceId)!.totalTtc,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

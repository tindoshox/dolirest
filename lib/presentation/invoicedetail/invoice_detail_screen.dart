import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
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
              valueListenable: Hive.box<InvoiceModel>(BoxName.invoices.name)
                  .listenable(keys: [controller.customerId]),
              builder: (context, invoice, child) => CustomActionButton(
                  buttonText: 'Payment',
                  onTap: invoice.get(controller.invoiceId)!.remaintopay == '0'
                      ? null
                      : () {
                          bool connected = Storage.settings.get('connected');
                          if (connected) {
                            Get.toNamed(
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
                  bool connected = Storage.settings.get('connected');
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
            ? const LoadingIndicator(
                message: Text('loading...'),
              )
            : TabBarView(
                controller: controller.tabController,
                children: [
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<InvoiceModel>(BoxName.invoices.name)
                            .listenable(keys: [controller.invoiceId]),
                    builder: (context, invoices, child) => InvoiceDetailWidget(
                        onPressed: () {
                          bool connected = Storage.settings.get('connected');
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
                          valueListenable:
                              Hive.box<InvoiceModel>(BoxName.invoices.name)
                                  .listenable(keys: [controller.customerId]),
                          builder: (context, invoices, child) {
                            return invoices
                                        .get(controller.invoiceId)!
                                        .totalpaid ==
                                    0
                                ? const ListTile(
                                    title: Text(
                                      'No payments.',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : PaymentsDataTable(
                                    invoiceId: controller.invoiceId,
                                    totalTtc: invoices
                                        .get(controller.invoiceId)!
                                        .totalTtc,
                                  );
                          },
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

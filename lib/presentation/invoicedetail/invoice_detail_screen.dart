import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/invoicedetail/components/invoice_detail_widget.dart';
import 'package:dolirest/presentation/invoicedetail/components/payment_list.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/invoice_detail_controller.dart';

class InvoiceDetailScreen extends GetView<InvoiceDetailController> {
  const InvoiceDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final StorageService storage = Get.find();
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueListenableBuilder(
              valueListenable: storage.invoicesListenable(),
              builder: (context, invoice, child) => CustomActionButton(
                  buttonText: 'Payment',
                  onTap: invoice.get(controller.invoiceId)!.remaintopay == '0'
                      ? null
                      : () {
                          if (Get.find<NetworkController>().connected.value) {
                            Get.toNamed(
                              Routes.PAYMENT,
                              arguments: {
                                'invid': controller.invoiceId,
                                'socid': controller.customerId,
                                'fromhome': false
                              },
                            );
                          } else {
                            SnackBarHelper.networkSnackbar();
                          }
                        }),
            ),
            CustomActionButton(
                buttonText: 'Download',
                onTap: () {
                  if (Get.find<NetworkController>().connected.value) {
                    controller.generateDocument();
                  } else {
                    SnackBarHelper.networkSnackbar();
                  }
                } //=> ,
                ),
          ],
        ),
      ],
      appBar: AppBar(
        title: const Text('Invoice Detail'),
        actions: [getStatusIcon()],
        bottom: TabBar(
            controller: controller.tabController, tabs: controller.invoiceTabs),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingIndicator(
                message: Text('Loading payment history...'),
              )
            : TabBarView(
                controller: controller.tabController,
                children: [
                  ValueListenableBuilder(
                    valueListenable: storage.invoicesListenable(),
                    builder: (context, invoices, child) => InvoiceDetailWidget(
                        onPressed: () {
                          if (Get.find<NetworkController>().connected.value) {
                            controller.setDueDate();
                          }
                        },
                        customer: controller.customer.value,
                        invoice: invoices.get(controller.invoiceId)!),
                  ),
                  ValueListenableBuilder(
                    valueListenable: storage.invoicesListenable(),
                    builder: (context, invoices, child) {
                      return invoices.get(controller.invoiceId)!.totalpaid == 0
                          ? const ListTile(
                              title: Text(
                                'No payments.',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: PaymentsList(
                                invoiceId: controller.invoiceId,
                                totalTtc: invoices
                                    .get(controller.invoiceId)!
                                    .totalTtc,
                              ),
                            );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/invoicedetail/components/invoice_detail_widget.dart';
import 'package:dolirest/presentation/invoicedetail/components/payment_list.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/invoice_detail_controller.dart';

class InvoiceDetailScreen extends GetView<InvoiceDetailController> {
  const InvoiceDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final StorageService storage = Get.find();
    return Scaffold(
      persistentFooterButtons: _buildFooterButtons(storage),
      appBar: _buildAppBar(),
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
                        invoice: invoices.get(controller.documentId)!),
                  ),
                  ValueListenableBuilder(
                    valueListenable: storage.invoicesListenable(),
                    builder: (context, invoices, child) {
                      return invoices.get(controller.documentId)!.totalpaid == 0
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
                                invoiceId: controller.documentId,
                                totalTtc: invoices
                                    .get(controller.documentId)!
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

  _buildAppBar() {
    return AppBar(
      title: const Text('Invoice Detail'),
      actions: [getStatusIcon(), _getMenu()],
      bottom: TabBar(
          controller: controller.tabController, tabs: controller.invoiceTabs),
    );
  }

  _getMenu() {
    return PopupMenuButton(
      onSelected: (item) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Return Item'),
          onTap: () => controller.creditNote(productReturned: true),
        ),
        PopupMenuItem(
          child: Text('Write-off Item'),
          onTap: () => controller.creditNote(productReturned: false),
        )
      ],
    );
  }

  _buildFooterButtons(StorageService storage) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ValueListenableBuilder(
            valueListenable: storage.invoicesListenable(),
            builder: (context, box, child) {
              var invoice = box.get(controller.documentId);
              return Row(
                children: [
                  if (invoice!.status == DocumentStatus.draft)
                    CustomActionButton(
                        buttonText: 'Validate',
                        onTap: () =>
                            (Get.find<NetworkController>().connected.value)
                                ? controller.validateDraft(invoice.id)
                                : SnackBarHelper.networkSnackbar()),
                  if (invoice.status == DocumentStatus.unpaid &&
                      invoice.type == DocumentType.typeCreditNote)
                    CustomActionButton(
                      buttonText: 'Close',
                      onTap: () {},
                    ),
                  if (invoice.type == DocumentType.invoice &&
                      invoice.remaintopay != "0")
                    CustomActionButton(
                        buttonText: 'Payment',
                        onTap: () =>
                            (Get.find<NetworkController>().connected.value)
                                ? Get.toNamed(
                                    Routes.PAYMENT,
                                    arguments: {
                                      'documentId': controller.documentId,
                                      'socid': controller.customerId,
                                    },
                                  )
                                : SnackBarHelper.networkSnackbar()),
                  SizedBox(
                    width: 10,
                  ),
                  CustomActionButton(
                    buttonText: invoice.status == '0'
                        ? 'Delete'
                        : (invoice.status == '1' ? 'Delete' : 'Download'),
                    onTap: () {
                      if (Get.find<NetworkController>().connected.value) {
                        invoice.status == '0'
                            ? controller.deleteDocument(invoiceId: invoice.id)
                            : controller.generateDocument();
                      } else {
                        SnackBarHelper.networkSnackbar();
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ];
  }
}

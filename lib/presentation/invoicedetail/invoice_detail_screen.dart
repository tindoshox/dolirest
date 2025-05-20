import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
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
    var document = controller.document.value;
    return Scaffold(
      persistentFooterButtons: _buildFooterButtons(document),
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingIndicator(
                message: Text('Loading payment history...'),
              )
            : TabBarView(
                controller: controller.tabController,
                children: [
                  InvoiceDetailWidget(
                      onPressed: () {
                        if (Get.find<NetworkController>().connected.value) {
                          controller.setDueDate();
                        }
                      },
                      customer: controller.customer.value,
                      invoice: controller.document.value),
                  controller.document.value.totalpaid == 0
                      ? const ListTile(
                          title: Text(
                            'No payments.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: PaymentsList(
                            invoiceId: controller.documentId,
                            totalTtc: controller.document.value.totalTtc,
                            payments: controller.payments,
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  _buildAppBar() {
    final document = controller.document.value;
    return AppBar(
      title: const Text('Invoice Detail'),
      actions: [
        getStatusIcon(),
        if (document.type == DocumentType.invoice &&
            document.paye == PaidStatus.unpaid &&
            document.remaintopay != '0')
          _getMenu()
      ],
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

  _buildFooterButtons(InvoiceModel document) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              //Show button to validate a draft
              if (document.status == ValidationStatus.draft &&
                  document.paye == PaidStatus.unpaid &&
                  document.lines!.isNotEmpty)
                CustomActionButton(
                  buttonText: 'Validate',
                  onTap: () => (Get.find<NetworkController>().connected.value)
                      ? controller.validateDocument(
                          id: document.id,
                          invoiceValidation:
                              document.type == DocumentType.invoice)
                      : SnackBarHelper.networkSnackbar(),
                ),
              //Close a credit note
              if (document.status == ValidationStatus.creditAvalable &&
                  document.type == DocumentType.typeCreditNote &&
                  document.paye == PaidStatus.unpaid)
                CustomActionButton(
                  buttonText: 'Close',
                  onTap: () => controller.closeCreditNote(),
                ),
              //Show payment button
              if (document.type == DocumentType.invoice &&
                  document.status == ValidationStatus.validated &&
                  document.remaintopay != "0")
                CustomActionButton(
                  buttonText: 'Payment',
                  onTap: () => (Get.find<NetworkController>().connected.value)
                      ? Get.toNamed(
                          Routes.PAYMENT,
                          arguments: {
                            'invoiceId': controller.documentId,
                            'socid': controller.customerId,
                          },
                        )
                      : SnackBarHelper.networkSnackbar(),
                ),
              SizedBox(
                width: 10,
              ),
              if (document.status == ValidationStatus.draft &&
                  document.paye == PaidStatus.unpaid)
                CustomActionButton(
                  buttonText: 'Delete',
                  onTap: () {
                    controller.deleteDocument(documentId: document.id);
                  },
                ),
              if (document.type == DocumentType.invoice &&
                  document.status == ValidationStatus.validated)
                CustomActionButton(
                  buttonText: 'Statement',
                  onTap: () => Get.find<NetworkController>().connected.value
                      ? controller.generateDocument()
                      : SnackBarHelper.networkSnackbar(),
                ),
            ],
          )
        ],
      ),
    ];
  }
}

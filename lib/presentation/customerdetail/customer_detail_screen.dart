import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_info_widget.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_invoice_list_widget.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerDetailScreen extends GetView<CustomerdetailController> {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        CustomActionButton(
            buttonText: 'Edit',
            onTap: () {
              bool connected = getBox.read('connected');
              if (connected) {
                Get.offAndToNamed(Routes.EDITCUSTOMER,
                    arguments: {'customerId': controller.customerId});
              }
            }),
        CustomActionButton(
            buttonText: 'New Invoice',
            onTap: () {
              bool connected = getBox.read('connected');
              if (connected) {
                Get.offAndToNamed(Routes.CREATEINVOICE, arguments: {
                  'customerId': controller.customerId,
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
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingIndicator(
                message: Text('loading...'),
              )
            : TabBarView(
                controller: controller.tabController,
                children: [
                  ValueListenableBuilder<Box>(
                      valueListenable:
                          Hive.box<ThirdPartyModel>(BoxName.customers.name)
                              .listenable(keys: [controller.customerId]),
                      builder: (context, customers, child) => CustomerInfo(
                          customer: customers.get(controller.customerId))),
                  ValueListenableBuilder(
                      valueListenable:
                          Hive.box<InvoiceModel>(BoxName.invoices.name)
                              .listenable(keys: [controller.customerId]),
                      builder: (context, value, child) {
                        var invoices = value
                            .toMap()
                            .values
                            .toList()
                            .where((inv) => inv.socid == controller.customerId)
                            .toList();
                        return InvoiceListWidget(invoices: invoices);
                      }),
                ],
              ),
      ),
    );
  }
}

import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/storage/storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_info_widget.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_invoice_list_widget.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomerDetailScreen extends GetView<CustomerDetailController> {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageController storageController = Get.find();
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: _buildFooterButtons(),
      appBar: AppBar(
        title: const Text('Customer Details'),
        bottom: TabBar(
            controller: controller.tabController,
            tabs: controller.customerTabs),
      ),
      body: _buildBody(storageController),
    );
  }

  List<Widget> _buildFooterButtons() {
    return [
      _actionButton('Edit', Routes.EDITCUSTOMER),
      _actionButton('New Invoice', Routes.CREATEINVOICE,
          additionalArgs: {'fromhome': false}),
    ];
  }

  Widget _actionButton(String buttonText, String route,
      {Map<String, dynamic>? additionalArgs}) {
    return CustomActionButton(
      buttonText: buttonText,
      onTap: () async {
        if (Get.find<NetworkController>().connected.value) {
          Get.offAndToNamed(route, arguments: {
            'customerId': controller.customerId,
            ...?additionalArgs
          });
        } else {
          SnackbarHelper.networkSnackbar();
        }
      },
    );
  }

  Widget _buildBody(StorageController storageController) {
    return Obx(() => controller.isLoading.value
        ? const LoadingIndicator(message: Text('Loading...'))
        : TabBarView(
            controller: controller.tabController,
            children: [
              _customerInfoTab(storageController),
              _invoicesTab(),
            ],
          ));
  }

  Widget _customerInfoTab(StorageController storageController) {
    return ValueListenableBuilder<Box>(
      valueListenable:
          storageController.customersListenable(keys: [controller.customerId]),
      builder: (context, box, child) {
        final customer = box.get(controller.customerId);
        return CustomerInfoWidget(
          customer: customer,
        );
      },
    );
  }

  Widget _invoicesTab() {
    final StorageController storageController = Get.find();
    return ValueListenableBuilder<Box>(
      valueListenable:
          storageController.invoicesListenable(keys: [controller.customerId]),
      builder: (context, box, child) {
        List<InvoiceModel> invoices = box.values
            .where((invoice) => invoice.socid == controller.customerId)
            .toList()
            .cast();
        return invoices.isEmpty
            ? const ListTile(
                title: Text('No invoices.', textAlign: TextAlign.center))
            : InvoiceListWidget(invoices: invoices);
      },
    );
  }
}

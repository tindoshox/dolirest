import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_info_widget.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_invoice_list_widget.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailScreen extends GetView<CustomerDetailController> {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StorageService storage = Get.find();
    return Scaffold(
      floatingActionButton: storage
              .getInvoiceList(customerId: controller.customerId)
              .isNotEmpty
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () => controller.deleteCustomer(controller.customerId),
              child: const Icon(Icons.delete),
            ),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: _buildFooterButtons(),
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: [getStatusIcon()],
        bottom: TabBar(
            controller: controller.tabController,
            tabs: controller.customerTabs),
      ),
      body: _buildBody(),
    );
  }

  List<Widget> _buildFooterButtons() {
    return [
      _actionButton('Edit', Routes.EDITCUSTOMER),
      _actionButton('New Invoice', Routes.CREATEINVOICE,
          additionalArgs: {'invoiceId': ''}),
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
          SnackBarHelper.networkSnackbar();
        }
      },
    );
  }

  Widget _buildBody() {
    return Obx(() => controller.isLoading.value
        ? const LoadingIndicator(message: Text('Loading...'))
        : TabBarView(
            controller: controller.tabController,
            children: [
              _customerInfoTab(),
              _invoicesTab(),
            ],
          ));
  }

  Widget _customerInfoTab() {
    final customer = controller.customer.value;
    return customer.id == null
        ? Center()
        : CustomerInfoWidget(
            customer: customer,
          );
  }

  Widget _invoicesTab() {
    final invoices = controller.invoices
        .where((invoice) => invoice.socid == controller.customerId)
        .toList();
    return invoices.isEmpty
        ? const ListTile(
            title: Text('No invoices.', textAlign: TextAlign.center))
        : InvoiceListWidget(
            invoices: invoices,
            controller: controller,
          );
  }
}

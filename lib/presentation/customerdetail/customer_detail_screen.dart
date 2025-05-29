import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_info_widget.dart';
import 'package:dolirest/presentation/customerdetail/components/customer_invoice_list_widget.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:dolirest/presentation/widgets/status_icon.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailScreen extends GetView<CustomerDetailController> {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          Obx(() => controller.invoices.isEmpty && !controller.isLoading.value
              ? FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () => Get.find<NetworkController>().connected.value
                      ? controller.deleteCustomer()
                      : SnackBarHelper.networkSnackbar(),
                  child: const Icon(Icons.delete),
                )
              : SizedBox()),
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: _buildFooterButtons(),
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: [
          getStatusIcon(
            onPressed: () => controller.refreshCustomerInvoiceData(),
          ),
          if (controller.moduleEnabledStatement.value) _getMenu()
        ],
        bottom: TabBar(
            controller: controller.tabController,
            tabs: controller.customerTabs),
      ),
      body: _buildBody(),
    );
  }

  _getMenu() {
    return PopupMenuButton(
      onSelected: (item) {},
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Statement'),
          onTap: () => _buildDateForm(context),
        ),
      ],
    );
  }

  List<Widget> _buildFooterButtons() {
    return [
      _actionButton(
        'Edit',
        Routes.EDITCUSTOMER,
      ),
      _actionButton('New Invoice', Routes.CREATEINVOICE),
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
    return customer.customerId == null
        ? Center()
        : CustomerInfoWidget(
            customer: customer,
          );
  }

  Widget _invoicesTab() {
    final invoices = controller.invoices
        .where(
            (invoice) => invoice.socid == controller.customer.value.customerId)
        .toList();
    return invoices.isEmpty
        ? const ListTile(
            title: Text('No invoices.', textAlign: TextAlign.center))
        : InvoiceListWidget(
            customer: controller.customer.value,
            invoices: invoices,
            controller: controller,
          );
  }

  _buildDateForm(BuildContext context) {
    return Get.defaultDialog(
      title: 'Customer Statement',
      content: Form(
        key: controller.dateFormkey,
        child: Column(
          children: [
            _startDateField(),
            _endDateField(),
            _submitButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _startDateField() {
    return CustomFormField(
      name: 'start_date',
      prefixIcon: const Icon(
        Icons.date_range,
        color: Colors.orangeAccent,
      ),
      validator: (startDate) =>
          controller.startDate.value.isAfter(DateTime.now())
              ? 'Date cannot be in the future'
              : null,
      controller: controller.startDateController,
      labelText: 'Start Date',
      suffix: IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.orangeAccent,
          ),
          onPressed: () => controller.setStartDate()),
    );
  }

  Widget _endDateField() {
    return CustomFormField(
      name: 'end_date',
      prefixIcon: const Icon(
        Icons.date_range,
        color: Colors.redAccent,
      ),
      validator: (endDate) =>
          controller.endDate.value.isBefore(controller.startDate.value)
              ? 'End Date must be after start date'
              : null,
      controller: controller.endDateController,
      labelText: 'End Date',
      suffix: IconButton(
          icon: const Icon(
            Icons.calendar_today,
            color: Colors.redAccent,
          ),
          onPressed: () => controller.setEndDate()),
    );
  }

  Widget _submitButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomActionButton(
              controller: controller,
              buttonText: 'Download',
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                controller.generateStatement();
              }),
          SizedBox(width: 3),
          CustomActionButton(
              controller: controller,
              buttonText: 'Cancel',
              isCancel: true,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Get.back();
              }),
        ],
      ),
    );
  }
}

import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/customer_list_tile.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'controllers/customer_list_controller.dart';

class CustomerListScreen extends GetView<CustomerListController> {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 1000));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to top',
        onPressed: () => controller.scrollController.animateTo(0,
            duration: const Duration(milliseconds: 200), curve: Curves.linear),
        child: const Icon(Icons.arrow_upward),
      ),
      appBar: AppBar(
        title: Obx(
          () => controller.searchIconVisible.value
              ? const Text('Customers')
              : _buildSearchField(debouncer),
        ),
        actions: [
          Obx(() => _buildSearchActionButton()),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(10),
        child: _CustomerList(),
      ),
    );
  }

  Widget _buildSearchField(Debouncer debouncer) {
    return CustomFormField(
      name: 'search',
      autofocus: true,
      textInputAction: TextInputAction.done,
      hintText: 'Search by name, address or phone number',
      controller: controller.searchController,
      onChanged: (string) => debouncer(() {
        controller.search(searchText: string!);
      }),
    );
  }

  Widget _buildSearchActionButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: controller.searchIconVisible.value
            ? const Icon(Icons.search)
            : const Icon(Icons.cancel),
        onPressed: () {
          if (!controller.searchIconVisible.value) {
            controller.searchController.clear();
            controller.searchString.value = "";
          }
          controller.searchIconVisible.value =
              !controller.searchIconVisible.value;
        },
      ),
    );
  }
}

class _CustomerList extends GetView<CustomerListController> {
  const _CustomerList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() => controller.isLoading.isTrue
              ? const LoadingIndicator(
                  message: Text('Refreshing customer data'))
              : _buildCustomerList()),
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    StorageService storage = Get.find();
    String search = controller.searchString.value;

    return RefreshIndicator(
      onRefresh: () => controller.refreshCustomerList(),
      child: ValueListenableBuilder(
        valueListenable: storage.customersListenable(),
        builder: (context, box, child) {
          //  List<CustomerModel> customers = box.values.toList();
          List<CustomerModel> noInvoiceCustomers = [];
          for (var customer in box.values.toList()) {
            var invoices = controller.storage
                .getInvoiceList()
                .where((invoice) => invoice.socid == customer.id)
                .toList();
            if (invoices.isEmpty) {
              noInvoiceCustomers.add(customer);
            }
          }

          List<CustomerModel> sortedValues = controller.noInvoiceCustomers
              ? noInvoiceCustomers
              : box.values.toList()
            ..sort((a, b) => a.name.compareTo(b.name));

          List<CustomerModel> customers = search.length > 2
              ? sortedValues
                  .where((customer) =>
                      customer.name
                          .toString()
                          .toUpperCase()
                          .contains(search.toUpperCase()) ||
                      customer.address
                          .toString()
                          .toUpperCase()
                          .contains(search.toUpperCase()) ||
                      customer.town
                          .toString()
                          .toUpperCase()
                          .contains(search.toUpperCase()) ||
                      customer.phone.toString().contains(search) ||
                      customer.fax.toString().contains(search))
                  .toList()
              : sortedValues;
          return customers.isEmpty
              ? ListTile(
                  title: const Text('No customers found',
                      textAlign: TextAlign.center),
                  trailing: ElevatedButton(
                      onPressed: () => controller.refreshCustomerList(),
                      child: const Text('Refresh')),
                )
              : ListView.builder(
                  controller: controller.scrollController,
                  itemCount: customers.length + 1,
                  itemBuilder: (context, index) {
                    if (index < customers.length) {
                      CustomerModel customer = customers[index];
                      return buildCustomerListTile(customer, context);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(child: Text('nothing more to load!')),
                      );
                    }
                  });
        },
      ),
    );
  }
}

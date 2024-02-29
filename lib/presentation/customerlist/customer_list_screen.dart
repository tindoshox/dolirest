import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/customerlist/components/customer_list_loading_tile.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'controllers/customer_list_controller.dart';

class CustomerlistScreen extends GetView<CustomerlistController> {
  const CustomerlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            onPressed: () =>
                Get.toNamed(Routes.EDITCUSTOMER, arguments: {'customerId': ''}),
            icon: const Icon(Icons.add),
            tooltip: 'New Customer',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomFormField(
                name: 'search',
                labelText: 'Search',
                suffix: const Icon(Icons.search),
                controller: controller.searchController,
                onChanged: (string) {
                  debouncer(() {
                    controller.initialSearch(string!);
                  });
                }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return ListView.separated(
                      itemBuilder: (context, index) =>
                          const ThirdPartyListLoadingTile(),
                      separatorBuilder: (context, index) => const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                      itemCount: 15);
                }
                if (controller.customers.isEmpty) {
                  return const Text('Customer not found');
                }

                var customers = controller.customers;
                var loadingMore = controller.isLoadingMore.value;
                return Obx(
                  () => ListView.builder(
                      controller: controller.scrollController,
                      itemCount: customers.length + 1,
                      itemBuilder: (context, index) {
                        if (index < customers.length) {
                          var customer = customers[index];
                          return InkWell(
                            onTap: () =>
                                Get.toNamed(Routes.CUSTOMERDETAIL, arguments: {
                              'customerId': customer.id.toString(),
                            }),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  customers[index].name,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    '${customer.address} ${customer.town}'
                                        .trim()),
                              ),
                            ),
                          );
                        } else {
                          if (loadingMore) {
                            return const ThirdPartyListLoadingTile();
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(child: Text('nothing more to load!')),
                          );
                        }
                      }),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

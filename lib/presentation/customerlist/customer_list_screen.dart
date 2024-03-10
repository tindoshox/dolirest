import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'controllers/customer_list_controller.dart';

class CustomerlistScreen extends GetView<CustomerlistController> {
  const CustomerlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Got to top',
        onPressed: () => controller.scrollController.animateTo(0,
            duration: const Duration(milliseconds: 200), curve: Curves.linear),
        child: const Icon(Icons.arrow_upward),
      ),
      appBar: AppBar(
        title: const Text('Customers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomFormField(
                border: const OutlineInputBorder(),
                name: 'search',
                labelText: 'Search',
                textInputAction: TextInputAction.done,
                hintText: 'Search by name, address or phone number',
                controller: controller.searchController,
                onChanged: (string) {
                  debouncer(() {
                    controller.search(searchText: string!);
                  });
                }),
            Obx(() => Text(controller.isLoading.value
                ? 'Refreshing data...'
                : 'Swipe down to refresh')),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.customers.isEmpty) {
                  return const Text('Customer not found');
                }

                var customers = controller.customers;
                // var loadingMore = controller.isLoadingMore.value;
                return Obx(
                  () => RefreshIndicator(
                    onRefresh: () => controller.getAllCustomers(),
                    child: Scrollbar(
                      child: ListView.builder(
                          controller: controller.scrollController,
                          itemCount: customers.length + 1,
                          itemBuilder: (context, index) {
                            if (index < customers.length) {
                              var customer = customers[index];
                              return InkWell(
                                onTap: () => Get.toNamed(Routes.CUSTOMERDETAIL,
                                    arguments: {
                                      'customerId': customer.id.toString(),
                                      'refresh': false,
                                    }),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      customers[index].name!,
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
                              // if (loadingMore) {
                              //   return const ThirdPartyListLoadingTile();
                              // }
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                    child: Text('nothing more to load!')),
                              );
                            }
                          }),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

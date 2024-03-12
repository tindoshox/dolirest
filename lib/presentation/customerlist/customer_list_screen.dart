import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
              },
            ),
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

                var search = controller.searchString.value;
                return RefreshIndicator(
                  onRefresh: () => controller.getAllCustomers(),
                  child: Scrollbar(
                    child: ValueListenableBuilder(
                      valueListenable:
                          Hive.box<ThirdPartyModel>('customers').listenable(),
                      builder: (context, value, child) {
                        var sortedValues = value.values.toList()
                          ..sort((a, b) => a.name.compareTo(b.name));
                        var customers = search != ""
                            ? sortedValues
                                .where((customer) =>
                                    customer.name.contains(search) ||
                                    customer.address
                                        .toString()
                                        .contains(search) ||
                                    customer.town.toString().contains(search) ||
                                    customer.phone
                                        .toString()
                                        .contains(search) ||
                                    customer.fax.toString().contains(search))
                                .toList()
                            : sortedValues;
                        return ListView.builder(
                            controller: controller.scrollController,
                            itemCount: customers.length + 1,
                            itemBuilder: (context, index) {
                              if (index < customers.length) {
                                var customer = customers[index];
                                return InkWell(
                                  onTap: () => Get.toNamed(
                                      Routes.CUSTOMERDETAIL,
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
                            });
                      },
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

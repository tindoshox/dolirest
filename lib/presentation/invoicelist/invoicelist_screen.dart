import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/invoicelist_controller.dart';

class InvoicelistScreen extends GetView<InvoicelistController> {
  const InvoicelistScreen({super.key});
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
        title: const Text('Invoices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            CustomFormField(
              name: 'search',
              labelText: 'Search',
              hintText: 'Search by name or invoice number',
              border: const OutlineInputBorder(),
              textInputAction: TextInputAction.done,
              controller: controller.searchController,
              onChanged: (string) {
                debouncer(() {
                  controller.search(searchText: string!);
                });
              },
            ),
            Obx(() => Text(controller.isLoading.value
                ? 'Refreshing data'
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
                  onRefresh: () => controller.getAllInvoices(),
                  child: Scrollbar(
                    child: ValueListenableBuilder(
                      valueListenable:
                          Hive.box<InvoiceModel>('invoices').listenable(),
                      builder: (context, value, child) {
                        var list = value.values
                            .where((element) => element.remaintopay != "0")
                            .toList();
                        var sortedValues = list
                          ..sort((a, b) => a.nom.compareTo(b.nom));
                        var invoices = search != ""
                            ? sortedValues
                                .where(
                                  (invoice) =>
                                      invoice.nom.contains(
                                          controller.searchString.value) ||
                                      invoice.ref.contains(
                                          controller.searchString.value),
                                )
                                .toList()
                            : sortedValues;
                        return ListView.builder(
                            controller: controller.scrollController,
                            itemCount: invoices.length + 1,
                            itemBuilder: (context, index) {
                              if (index < invoices.length) {
                                var invoice = invoices[index];
                                return InvoiceListTile(
                                    invoices: invoices, invoice: invoice);
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Center(child: Text('End of list!')),
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

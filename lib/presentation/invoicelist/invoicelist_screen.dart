import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        automaticallyImplyLeading: false,
        title: Obx(
          () => SizedBox(
            child: controller.searchIcon.value
                ? const Text('Invoices')
                : CustomFormField(
                    name: 'search',
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    hintText: 'Search by  name or invoice number',
                    controller: controller.searchController,
                    onChanged: (string) {
                      debouncer(() {
                        controller.search(searchText: string!);
                      });
                    },
                  ),
          ),
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: controller.searchIcon.value
                      ? const Icon(Icons.search)
                      : const Icon(Icons.cancel),
                  onPressed: () {
                    if (!controller.searchIcon.value) {
                      controller.searchController.clear();
                      controller.searchString.value = "";
                    }
                    controller.searchIcon.value = !controller.searchIcon.value;
                  },
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return const LoadingIndicator(
                    message: Text('Refreshing invoice data'),
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

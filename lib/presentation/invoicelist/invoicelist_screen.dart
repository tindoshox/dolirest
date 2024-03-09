import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/invoicelist/components/invoice_list_loading_tile.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'controllers/invoicelist_controller.dart';

class InvoicelistScreen extends GetView<InvoicelistController> {
  const InvoicelistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
              onPressed: () => controller.getAllInvoices(),
              icon: const Icon(Icons.refresh_outlined))
        ],
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
                }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.isTrue) {
                  return ListView.builder(
                      itemBuilder: (context, index) =>
                          const InvoiceListLoadingTile(),
                      itemCount: 15);
                }
                if (controller.invoices.isEmpty) {
                  return const Text('Invoice not found');
                }
                var invoices = controller.invoices
                    .where((element) => element.remaintopay != "0")
                    .toList();
                //var loadMore = controller.isLoadingMore.value;
                return ListView.builder(
                    controller: controller.scrollController,
                    itemCount: invoices.length + 1,
                    itemBuilder: (context, index) {
                      if (index < invoices.length) {
                        var invoice = invoices[index];
                        return InkWell(
                          onTap: () {
                            var invoice = invoices[index];
                            Get.toNamed(
                              Routes.INVOICEDETAIL,
                              arguments: {
                                'customerId': invoice.socid,
                                'invoiceId': invoice.id,
                                'refresh': false
                              },
                            );
                          },
                          child: Card(
                            child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      invoice.ref!,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'BALANCE: ${invoice.remaintopay}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(invoice.nom!),
                                        ),
                                        Text(
                                          intToDateString(
                                              invoice.dateLimReglement!),
                                          style: overDueStyle(
                                              invoice.dateLimReglement!),
                                        )
                                      ],
                                    ),
                                    //Product name
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(invoice.lines![0].productLabel ??
                                            invoice.lines![0].description),
                                        Text(
                                          invoice.sumpayed == null
                                              ? 'UNPAID'
                                              : 'STARTED',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        );
                      } else {
                        // if (loadMore) {
                        //   return const InvoiceListLoadingTile();
                        // }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(child: Text('End of list!')),
                        );
                      }
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}

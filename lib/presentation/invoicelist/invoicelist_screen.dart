import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/presentation/widgets/custom_form_field.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import 'controllers/invoicelist_controller.dart';

class InvoicelistScreen extends GetView<InvoicelistController> {
  const InvoicelistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to top',
        onPressed: () => controller.scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ),
        child: const Icon(Icons.arrow_upward),
      ),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Obx(() => controller.searchIcon.value
          ? const Text('Invoices')
          : buildSearchField()),
      actions: [buildSearchIcon()],
    );
  }

  Widget buildSearchField() {
    return CustomFormField(
      name: 'search',
      autofocus: true,
      textInputAction: TextInputAction.done,
      hintText: 'Search by name or invoice number',
      controller: controller.searchController,
      onChanged: (string) {
        final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
        debouncer(() {
          controller.search(searchText: string!);
        });
      },
    );
  }

  Widget buildSearchIcon() {
    return Obx(() => Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon:
                Icon(controller.searchIcon.value ? Icons.search : Icons.cancel),
            onPressed: () => controller.toggleSearch(),
          ),
        ));
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? const LoadingIndicator()
                : buildInvoiceList()),
          ),
        ],
      ),
    );
  }

  Widget buildInvoiceList() {
    String search = controller.searchString.value;
    var list = controller.invoices;

    List<InvoiceModel> invoices = search != ""
        ? list
            .where(
              (invoice) =>
                  invoice.name
                      .toString()
                      .toUpperCase()
                      .contains(controller.searchString.value.toUpperCase()) ||
                  invoice.ref.contains(controller.searchString.value) ||
                  invoice.refClient
                      .toString()
                      .contains(controller.searchString.value),
            )
            .toList()
        : list;
    return RefreshIndicator(
      onRefresh: () => controller.refreshInvoiceList(),
      child: invoices.isEmpty
          ? ListTile(
              title:
                  const Text('No invoices found', textAlign: TextAlign.center),
              trailing: ElevatedButton(
                  onPressed: () => controller.refreshInvoiceList(),
                  child: const Text('Refresh')),
            )
          : ListView.builder(
              controller: controller.scrollController,
              itemCount: invoices.length + 1,
              itemBuilder: (context, index) => index < invoices.length
                  ? InvoiceListTile(invoice: invoices[index])
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(child: Text('End of list!')),
                    ),
            ),
    );
  }
}

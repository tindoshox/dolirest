import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:flutter/material.dart';

class InvoiceListWidget extends StatelessWidget {
  const InvoiceListWidget({
    super.key,
    required this.invoices,
    required this.controller,
  });

  final List<InvoiceModel> invoices;
  final CustomerDetailController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          controller.refreshCustomerInvoiceData(customerId: controller.customerId),
      child: ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            return InvoiceListTile(invoice: invoices[index]);
          }),
    );
  }
}

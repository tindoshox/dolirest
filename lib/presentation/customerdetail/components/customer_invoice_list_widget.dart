import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:flutter/material.dart';

class InvoiceListWidget extends StatelessWidget {
  const InvoiceListWidget({
    super.key,
    required this.customer,
    required this.invoices,
    required this.controller,
  });
  final CustomerEntity customer;
  final List<InvoiceEntity> invoices;
  final CustomerDetailController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshCustomerInvoiceData(),
      child: ListView.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            return InvoiceListTile(
              invoice: invoices[index],
              customer: customer,
            );
          }),
    );
  }
}

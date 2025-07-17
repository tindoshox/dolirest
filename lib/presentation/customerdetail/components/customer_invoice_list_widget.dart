import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/presentation/customerdetail/controllers/customer_detail_controller.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:flutter/material.dart';

Widget invoiceList({
  required CustomerEntity customer,
  required List<InvoiceEntity> invoices,
  required CustomerDetailController controller,
}) {
  return RefreshIndicator(
    onRefresh: () => controller.refreshData(),
    child: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          return invoiceListTile(
            context: context,
            customer: customer,
            invoice: invoices[index],
          );
        }),
  );
}

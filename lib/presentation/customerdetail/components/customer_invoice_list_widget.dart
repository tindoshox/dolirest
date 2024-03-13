import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/presentation/widgets/invoice_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/utils.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/utils.dart';

class InvoiceListWidget extends StatelessWidget {
  const InvoiceListWidget({
    super.key,
    required this.invoices,
  });

  final List<InvoiceModel> invoices;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          return InvoiceListTile(invoices: invoices, invoice: invoices[index]);
        });
  }
}

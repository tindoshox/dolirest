import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
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
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: Colors.grey,
        thickness: 1,
      ),
      itemCount: invoices.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          var invoice = invoices[index];
          Get.toNamed(
            Routes.INVOICEDETAIL,
            arguments: {
              'invoiceId': invoice.id,
              'customerId': invoice.socid,
              'refresh': false,
            },
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoices[index].ref!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'BALANCE: ${invoices[index].remaintopay}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(invoices[index].lines![0].productLabel ??
                invoices[index].lines![0].description),
            Text(
                'Due Date: ${intToDateString(invoices[index].dateLimReglement!)}')
          ],
        ),
      ),
    );
  }
}

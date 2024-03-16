import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile({
    super.key,
    required this.invoices,
    required this.invoice,
  });

  final List<InvoiceModel> invoices;
  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Get.toNamed(
            Routes.INVOICEDETAIL,
            arguments: {
              'customerId': invoice.socid,
              'invoiceId': invoice.id,
            },
          );
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'BALANCE: ${invoice.remaintopay}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Flexible(
                      child: Text(
                    invoice.nom!,
                    overflow: TextOverflow.ellipsis,
                  )),
                ),
                Text(
                  intToDateString(invoice.dateLimReglement!),
                  style: overDueStyle(invoice.dateLimReglement!),
                )
              ],
            ),
            //Product name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(invoice.lines![0].productLabel ??
                    invoice.lines![0].description),
                Text(
                  invoice.sumpayed == null ? 'UNPAID' : 'STARTED',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

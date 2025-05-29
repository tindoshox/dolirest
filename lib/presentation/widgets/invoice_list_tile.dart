import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/string_manager.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';

class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile(
      {super.key, required this.invoice, required this.customer});

  final InvoiceEntity invoice;
  final CustomerEntity customer;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Initicon(
          text: customer.name ?? 'Please refresh customers',
          size: 30,
        ),
        isThreeLine: true,
        onTap: () => _onInvoiceTap(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref ?? '', // Handle potential null
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              invoice.type == DocumentType.typeCreditNote &&
                      invoice.paye == PaidStatus.paid
                  ? 'BALANCE: 0'
                  : 'BALANCE: ${invoice.remaintopay}',
              style: Theme.of(context).textTheme.titleSmall,
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
                  child: Text(
                    customer.name ??
                        'Please refresh customer list', // Handle potential null
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                Text(
                  Utils.intToDMY(
                      invoice.dateLimReglement!), // Handle potential null
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Utils.overDueStyle(invoice.dateLimReglement!)),
                )
              ],
            ),
            Text(
              '${customer.town} ${customer.address}'.trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice.lines.isNotEmpty
                      ? invoice.lines[0].productLabel ??
                          invoice.lines[0].description ??
                          'N/A'
                      : 'N/A',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  invoice.type == DocumentType.typeCreditNote &&
                          invoice.paye == PaidStatus.paid
                      ? 'CREDITED'
                      : invoice.remaintopay == "0" &&
                              invoice.status != ValidationStatus.draft
                          ? "FULLY PAID"
                          : (invoice.totalpaid == 0 ? 'UNPAID' : 'STARTED'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onInvoiceTap() {
    Get.toNamed(
      Routes.INVOICEDETAIL,
      arguments: {
        'customerId': invoice.socid,
        'documentId': invoice.documentId,
      },
    );
  }
}

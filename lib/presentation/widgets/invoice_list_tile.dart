import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';

class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile({
    super.key,
    required this.invoice,
  });

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final CustomerModel? customer = storage.getCustomer(invoice.socid);
    return Card(
      child: ListTile(
        leading: Initicon(
          text: customer!.name,
          size: 30,
        ),
        isThreeLine: true,
        onTap: () => _onInvoiceTap(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref ?? 'N/A', // Handle potential null
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              'BALANCE: ${invoice.remaintopay}',
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
                      invoice.dateLimReglement ?? ''), // Handle potential null
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Utils.overDueStyle(invoice.dateLimReglement)),
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
                  invoice.lines?.isNotEmpty ?? false
                      ? invoice.lines![0].productLabel ??
                          invoice.lines![0].description ??
                          'N/A'
                      : 'N/A',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  invoice.remaintopay == "0"
                      ? "FULLY PAID"
                      : (invoice.sumpayed == null ? 'UNPAID' : 'STARTED'),
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
        'documentId': invoice.id,
      },
    );
  }
}

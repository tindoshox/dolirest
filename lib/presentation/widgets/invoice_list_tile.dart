import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceListTile extends StatelessWidget {
  const InvoiceListTile({
    super.key,
    required this.invoice,
  });

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageController>();
    final CustomerModel? customer = storage.getCustomer(invoice.socid);
    return Card(
      child: ListTile(
        isThreeLine: true,
        onTap: () => _onInvoiceTap(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref ?? 'N/A', // Handle potential null
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
                  child: Text(
                    customer?.name ??
                        'Please refresh customer list', // Handle potential null
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  Utils.intToDMY(
                      invoice.dateLimReglement ?? ''), // Handle potential null
                  style: Utils.overDueStyle(invoice.dateLimReglement ?? ''),
                ),
              ],
            ),
            Text(
              '${customer?.town} ${customer?.address}'.trim(),
              style: const TextStyle(fontSize: 10),
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
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  invoice.remaintopay == "0"
                      ? "FULLY PAID"
                      : (invoice.sumpayed == null ? 'UNPAID' : 'STARTED'),
                  style: const TextStyle(fontSize: 10),
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
        'invoiceId': invoice.id,
      },
    );
  }
}

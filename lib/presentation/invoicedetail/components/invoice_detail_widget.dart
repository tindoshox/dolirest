import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/customer_by_id_model.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_by_id_model.dart';
import 'package:dolirest/utils/utils.dart';

class InvoiceDetailWidget extends StatelessWidget {
  const InvoiceDetailWidget(
      {super.key,
      required this.onPressed,
      required this.customer,
      required this.invoice});

  final InvoiceById invoice;
  final ThirdPartyById customer;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      ListTile(
        isThreeLine: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (invoice.refClient != null)
              Text(
                'Deliver Note: ${invoice.refClient}',
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.name ?? '',
            ),
            Text('Balance Due: ${invoice.remaintopay}')
          ],
        ),
      ),
      ListTile(
        title: Text(
          invoice.remaintopay == '0'
              ? ''
              : 'Due Date: ${intToDateString(invoice.dateLimReglement)}',
          style: overDueStyle(invoice.dateLimReglement),
        ),
        subtitle: Text('Invoice Date ${intToDateString(invoice.date)}'),
        trailing: invoice.remaintopay == '0'
            ? null
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onPressed,
              ),
      ),
      ListTile(
        isThreeLine: true,
        title: Text(
          '${customer.address} ${customer.town}',
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            if (customer.phone != null && customer.phone.toString() != '')
              InkWell(
                  onTap: () => makePhoneCall(customer.phone.toString().trim()),
                  child: Text(customer.phone.toString())),
            const SizedBox(
              height: 20,
            ),
            if (customer.fax != null && customer.fax.toString() != '')
              InkWell(
                  onTap: () => makePhoneCall(customer.fax.toString().trim()),
                  child: Text(customer.fax.toString())),
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          if (invoice.lines!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(invoice.lines![0].productLabel ??
                      invoice.lines![0].description),
                  Text(amounts(invoice.lines![0].totalTtc.toString()))
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
                '${invoice.lines![0].qty} x ${amounts(invoice.lines![0].totalTtc.toString())}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(invoice.lines![0].productLabel ??
                invoice.lines![0].description),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total: ${amounts(invoice.totalTtc)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Paid: ${(int.parse(amounts(invoice.totalTtc)) - int.parse(invoice.remaintopay))}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Balance: ${invoice.remaintopay}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    ];

    return ListView.separated(
        itemBuilder: (context, index) {
          var child = children[index];
          return child;
        },
        separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
        itemCount: children.length);
  }
}

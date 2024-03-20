import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/utils/utils.dart';

class InvoiceDetailWidget extends StatelessWidget {
  const InvoiceDetailWidget(
      {super.key,
      required this.onPressed,
      required this.customer,
      required this.invoice});

  final InvoiceModel invoice;
  final ThirdPartyModel customer;
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
              : 'Due Date: ${Utils.intToDayFirst(invoice.dateLimReglement)}',
          style: Utils.overDueStyle(invoice.dateLimReglement),
        ),
        subtitle: Text('Invoice Date ${Utils.intToDayFirst(invoice.date)}'),
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
          '${customer.town}: ${customer.address}',
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
                  onTap: () =>
                      Utils.makePhoneCall(customer.phone.toString().trim()),
                  child: Text(customer.phone.toString())),
            const SizedBox(
              height: 20,
            ),
            if (customer.fax != null && customer.fax.toString() != '')
              InkWell(
                  onTap: () =>
                      Utils.makePhoneCall(customer.fax.toString().trim()),
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
                  Text(Utils.amounts(invoice.lines![0].totalTtc.toString()))
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
                '${invoice.lines![0].qty} x ${Utils.amounts(invoice.lines![0].totalTtc.toString())}'),
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
                const Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Paid:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Balance:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Utils.amounts(invoice.totalTtc!),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${int.parse(Utils.amounts(invoice.sumpayed))}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${invoice.remaintopay}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
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

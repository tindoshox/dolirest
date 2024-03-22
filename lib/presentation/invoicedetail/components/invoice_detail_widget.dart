import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/widgets.dart';

class InvoiceDetailWidget extends StatelessWidget {
  const InvoiceDetailWidget({
    super.key,
    required this.onPressed,
    required this.customer,
    required this.invoice,
  });

  final InvoiceModel invoice;
  final CustomerModel customer;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final children = _buildChildren();
    return ListView.separated(
      itemBuilder: (_, index) => children[index],
      separatorBuilder: (_, __) =>
          const Divider(color: Colors.grey, thickness: 1),
      itemCount: children.length,
    );
  }

  List<Widget> _buildChildren() {
    return [
      _buildInvoiceHeader(),
      _buildCustomerDetails(),
      _buildDueDateTile(),
      _buildInvoiceItems(),
      _buildTotals(invoice)
    ];
  }

  Widget _buildInvoiceHeader() {
    return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (invoice.refClient != null)
              Text('Deliver Note: ${invoice.refClient}'),
          ],
        ),
        subtitle: Text('Balance Due: ${invoice.remaintopay}'));
  }

  Widget _buildDueDateTile() {
    return ListTile(
      title: Text(
        invoice.remaintopay == '0'
            ? ''
            : 'Due Date: ${Utils.intToDayFirst(invoice.dateLimReglement)}',
        style: Utils.overDueStyle(invoice.dateLimReglement),
      ),
      subtitle: Text('Invoice Date ${Utils.intToDayFirst(invoice.date)}'),
      trailing: invoice.remaintopay == '0'
          ? null
          : IconButton(icon: const Icon(Icons.edit), onPressed: onPressed),
    );
  }

  Widget _buildCustomerDetails() {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customer.name ?? ''),
              Text(
                '${customer.town}: ${customer.address}',
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (customer.phone != null && customer.phone!.isNotEmpty)
                InkWell(
                    onTap: () => Utils.makePhoneCall(customer.phone!.trim()),
                    child: Text(customer.phone!)),
              if (customer.fax != null && customer.fax!.isNotEmpty)
                InkWell(
                    onTap: () => Utils.makePhoneCall(customer.fax!.trim()),
                    child: Text(customer.fax!)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInvoiceItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Row(
                    children: [
                      Text('Items',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Qty',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Unit',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.grey),
        if (invoice.lines != null && invoice.lines!.isNotEmpty)
          ...invoice.lines!.map((line) => _buildInvoiceLine(line)),
      ],
    );
  }

  Widget _buildInvoiceLine(Line line) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Text(
                      line.productLabel ?? line.description ?? '',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(line.qty ?? ''),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(Utils.amounts(line.subprice)),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(Utils.amounts(line.totalTtc.toString())),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotals(InvoiceModel invoice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Flexible(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Invoice Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Paid:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Balance:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Utils.amounts(invoice.totalTtc),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          Utils.amounts(invoice.sumpayed),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          invoice.remaintopay ?? '0',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

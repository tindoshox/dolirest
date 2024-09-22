import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/utils/utils.dart';

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
            : 'Due Date: ${Utils.intToDMY(invoice.dateLimReglement)}',
        style: Utils.overDueStyle(invoice.dateLimReglement),
      ),
      subtitle: Text('Invoice Date ${Utils.intToDMY(invoice.date)}'),
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
    //1
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          //1
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLineItemText(flex: 3, text: 'Item'),
              _buildLineItemText(text: 'Qty'),
              _buildLineItemText(text: 'Unit'),
              _buildLineItemText(text: 'Total'),
            ],
          ),
        ),
        const Divider(color: Colors.grey),
        if (invoice.lines != null && invoice.lines!.isNotEmpty)
          ...invoice.lines!.map((line) => _buildInvoiceLine(line)),
      ],
    );
  }

  Flexible _buildLineItemText(
      {String text = 'placeholder',
      int flex = 1,
      TextOverflow overflow = TextOverflow.ellipsis}) {
    return Flexible(
      flex: flex,
      child: Row(
        children: [
          Text(
            text,
            overflow: overflow,
            //style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceLine(Line line) {
    //2
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLineItemText(
                  flex: 3, text: line.productLabel ?? line.description ?? ''),
              _buildLineItemText(text: line.qty ?? ''),
              _buildLineItemText(text: Utils.amounts(line.subprice)),
              _buildLineItemText(text: Utils.amounts(line.totalTtc)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotals(InvoiceModel invoice) {
    //3
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildTotalsText(text: 'Invoice Total:'),
                        _buildTotalsText(text: 'paid:'),
                        _buildTotalsText(text: 'Balance:'),
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
                        _buildTotalsText(text: Utils.amounts(invoice.totalTtc)),
                        _buildTotalsText(text: Utils.amounts(invoice.sumpayed)),
                        _buildTotalsText(text: invoice.remaintopay ?? '0'),
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

  Text _buildTotalsText({String text = 'placeholder'}) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}

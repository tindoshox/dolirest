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
      _buildDueDateTile(),
      _buildCustomerDetails(),
      _buildInvoiceItems(),
    ];
  }

  Widget _buildInvoiceHeader() {
    return ListTile(
      isThreeLine: true,
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name ?? ''),
          Text('Balance Due: ${invoice.remaintopay}')
        ],
      ),
    );
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
      isThreeLine: true,
      title: Text(
        '${customer.town}: ${customer.address}',
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          if (customer.phone != null && customer.phone!.isNotEmpty)
            InkWell(
                onTap: () => Utils.makePhoneCall(customer.phone!.trim()),
                child: Text(customer.phone!)),
          const SizedBox(height: 20),
          if (customer.fax != null && customer.fax!.isNotEmpty)
            InkWell(
                onTap: () => Utils.makePhoneCall(customer.fax!.trim()),
                child: Text(customer.fax!)),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
            ],
          ),
        ),
        const Divider(color: Colors.grey),
        if (invoice.lines != null && invoice.lines!.isNotEmpty)
          ...invoice.lines!.map((line) => _buildInvoiceLine(line)),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }

  Widget _buildInvoiceLine(Line line) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(line.productLabel ?? line.description ?? ''),
              Text(Utils.amounts(line.totalTtc.toString())),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
                '${line.qty} x ${Utils.amounts(line.totalTtc.toString())}'),
          ),
          if (line.description !=
              null) // Only display if description is not null
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(line.description!),
            ),
        ],
      ),
    );
  }
}

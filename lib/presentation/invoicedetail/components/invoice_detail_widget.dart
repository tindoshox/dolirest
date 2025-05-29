import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';

class InvoiceDetailWidget extends StatelessWidget {
  const InvoiceDetailWidget({
    super.key,
    required this.onPressed,
    required this.customer,
    required this.invoice,
  });

  final InvoiceEntity invoice;
  final CustomerEntity customer;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    Widget buildInvoiceHeader() {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              invoice.ref ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (invoice.refCustomer != null)
              Text(
                'Delivery Note: ${invoice.ref}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        subtitle: Text(
          'Balance Due: ${invoice.remaintopay}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    Widget buildDueDateTile() {
      return ListTile(
        title: Text(
          invoice.remaintopay == "0"
              ? ''
              : 'Due Date: ${Utils.intToDMY(invoice.dateLimReglement!)}',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Utils.overDueStyle(invoice.dateLimReglement!)),
        ),
        subtitle: Text(
          'Invoice Date ${Utils.intToDMY(invoice.date!)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: invoice.remaintopay == "0"
            ? null
            : IconButton(icon: const Icon(Icons.edit), onPressed: onPressed),
      );
    }

    Widget buildCustomerDetails() {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name ?? '',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${customer.town}: ${customer.address}',
                  style: Theme.of(context).textTheme.bodySmall,
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
                      child: Text(
                        customer.phone!,
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
                if (customer.fax != null && customer.fax!.isNotEmpty)
                  InkWell(
                      onTap: () => Utils.makePhoneCall(customer.fax!.trim()),
                      child: Text(
                        customer.fax!,
                        style: Theme.of(context).textTheme.bodySmall,
                      )),
              ],
            )
          ],
        ),
      );
    }

    Flexible buildLineItemText({
      String text = 'placeholder',
      int flex = 1,
      TextOverflow overflow = TextOverflow.ellipsis,
    }) {
      return Flexible(
        flex: flex,
        child: Row(
          children: [
            Text(
              text,
              overflow: overflow,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    Widget buildInvoiceLine(InvoiceLineEntity line) {
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
                buildLineItemText(
                    flex: 3, text: line.productLabel ?? line.description ?? ''),
                buildLineItemText(text: line.qty ?? ''),
                buildLineItemText(text: Utils.amounts(line.subprice)),
                buildLineItemText(text: Utils.amounts(line.totalTtc)),
              ],
            ),
          ],
        ),
      );
    }

    Widget buildInvoiceItems() {
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
                buildLineItemText(flex: 3, text: 'Item'),
                buildLineItemText(text: 'Qty'),
                buildLineItemText(text: 'Unit'),
                buildLineItemText(text: 'Total'),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          if (invoice.lines.isNotEmpty)
            ...invoice.lines.map((line) => buildInvoiceLine(line)),
        ],
      );
    }

    Text buildTotalsText({String text = 'placeholder'}) {
      return Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      );
    }

    Widget buildTotals(InvoiceEntity invoice) {
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
                          buildTotalsText(text: 'Invoice Total:'),
                          buildTotalsText(text: 'paid:'),
                          buildTotalsText(text: 'Balance:'),
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
                          buildTotalsText(
                              text: Utils.amounts(invoice.totalTtc)),
                          buildTotalsText(
                              text: (invoice.totalpaid.toString() == '0.0'
                                  ? '0'
                                  : invoice.totalpaid.toString())),
                          buildTotalsText(text: invoice.remaintopay.toString()),
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

    List<Widget> buildChildren() {
      return [
        buildInvoiceHeader(),
        buildCustomerDetails(),
        buildDueDateTile(),
        buildInvoiceItems(),
        buildTotals(invoice)
      ];
    }

    final children = buildChildren();

    return ListView.separated(
      itemBuilder: (_, index) => children[index],
      separatorBuilder: (_, __) =>
          const Divider(color: Colors.grey, thickness: 1),
      itemCount: children.length,
    );
  }
}

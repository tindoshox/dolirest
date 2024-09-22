import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/third_party_model.dart';
import 'package:dolirest/infrastructure/dal/services/storage.dart';
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
    return Card(
      child: ListTile(
        onTap: () => _onInvoiceTap(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
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

  Widget _buildTitle() {
    return Row(
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
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomerRow(),
        _buildProductRow(),
      ],
    );
  }

  Widget _buildCustomerRow() {
    final CustomerModel? customer = Storage.customers.get(invoice.socid);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            customer?.name ?? 'Unknown', // Handle potential null
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          Utils.intToDMY(
              invoice.dateLimReglement ?? ''), // Handle potential null
          style: Utils.overDueStyle(invoice.dateLimReglement ?? ''),
        ),
      ],
    );
  }

  Widget _buildProductRow() {
    final productLabel = invoice.lines?.isNotEmpty ?? false
        ? invoice.lines![0].productLabel ??
            invoice.lines![0].description ??
            'N/A'
        : 'N/A'; // Safely access the first element

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(productLabel),
        Text(
          invoice.sumpayed == null ? 'UNPAID' : 'STARTED',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

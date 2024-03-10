import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/utils/utils.dart';

class PaymentsDataTable extends StatelessWidget {
  const PaymentsDataTable(
      {super.key, required this.payments, required this.invoice});
  final List<PaymentModel> payments;
  final InvoiceModel invoice;

  @override
  Widget build(Object context) {
    final columns = [
      'Date',
      'Receipt',
      'Amount',
      'Bal',
    ];
    Widget buildDataTable() {
      var price = int.parse(amounts(invoice.totalTtc));

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columnSpacing: 30,
            columns: getColumns(columns),
            rows: getRows(payments, price)),
      );
    }

    return buildDataTable();
  }
}

List<DataRow> getRows(List<PaymentModel> payments, int price) {
  return payments.map((PaymentModel payment) {
    price -= int.parse(amounts(payment.amount)).toInt();
    return DataRow(
        cells: getCells([
      Text(datePaid(payment.date!)),
      Text(payment.num ?? payment.type.toString().toLowerCase()),
      Text(amounts(payment.amount)),
      Text(price.toString()),
    ]));
  }).toList();
}

List<DataCell> getCells(List<dynamic> cells) =>
    cells.map((data) => DataCell(data)).toList();

List<DataColumn> getColumns(List<String> columns) =>
    columns.map((String column) => DataColumn(label: Text(column))).toList();

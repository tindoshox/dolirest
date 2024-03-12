import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/utils/utils.dart';

class PaymentsDataTable extends StatelessWidget {
  const PaymentsDataTable(
      {super.key, required this.payments, required this.totalTtc});
  final List<PaymentModel> payments;
  //final InvoiceModel invoice;
  final String totalTtc;

  @override
  Widget build(Object context) {
    final columns = [
      'Date',
      'Receipt',
      'Amount',
      'Bal',
    ];
    Widget buildDataTable() {
      var price = int.parse(amounts(totalTtc));

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
    price -= intAmounts(payment.amount);
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

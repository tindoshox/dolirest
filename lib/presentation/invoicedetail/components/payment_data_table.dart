import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PaymentsDataTable extends StatelessWidget {
  const PaymentsDataTable(
      {super.key, required this.totalTtc, required this.invoiceId});

  //final InvoiceModel invoice;
  final String totalTtc;
  final String invoiceId;

  @override
  Widget build(Object context) {
    final columns = [
      'Date',
      'Receipt',
      'Amount',
      'Bal',
    ];
    Widget buildDataTable() {
      var price = int.parse(Utils.amounts(totalTtc));

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder(
            valueListenable: Hive.box<List>(BoxName.payments.name).listenable(),
            builder: (context, value, child) {
              var payments =
                  value.get(invoiceId, defaultValue: [])!.cast<PaymentModel>();
              return DataTable(
                  columnSpacing: 30,
                  columns: getColumns(columns),
                  rows: getRows(payments, price));
            }),
      );
    }

    return buildDataTable();
  }
}

List<DataRow> getRows(List<PaymentModel> payments, int price) {
  return payments.map((PaymentModel payment) {
    price -= Utils.intAmounts(payment.amount);
    return DataRow(
        cells: getCells([
      Text(Utils.datePaid(payment.date!)),
      Text(payment.num ?? payment.type.toString().toLowerCase()),
      Text(Utils.amounts(payment.amount)),
      Text(price.toString()),
    ]));
  }).toList();
}

List<DataCell> getCells(List<dynamic> cells) =>
    cells.map((data) => DataCell(data)).toList();

List<DataColumn> getColumns(List<String> columns) =>
    columns.map((String column) => DataColumn(label: Text(column))).toList();

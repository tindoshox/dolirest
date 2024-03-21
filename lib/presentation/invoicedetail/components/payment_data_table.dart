import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PaymentsDataTable extends StatelessWidget {
  const PaymentsDataTable({
    super.key,
    required this.totalTtc,
    required this.invoiceId,
  });

  final String totalTtc;
  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    final List<String> columns = ['Date', 'Receipt', 'Amount', 'Bal'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder(
        valueListenable: Hive.box<List>(BoxName.payments.name).listenable(),
        builder: (BuildContext context, Box<List> box, Widget? child) {
          final List<PaymentModel> payments = box.get(invoiceId,
              defaultValue: <PaymentModel>[])!.cast<PaymentModel>();
          int price = int.parse(Utils.amounts(totalTtc));
          return DataTable(
            columnSpacing: 30,
            columns: _getColumns(columns),
            rows: _getRows(payments, price),
          );
        },
      ),
    );
  }

  List<DataRow> _getRows(List<PaymentModel> payments, int price) {
    return payments.map((PaymentModel payment) {
      price -= Utils.intAmounts(payment.amount);
      return DataRow(
          cells: _getCells([
        Text(Utils.datePaid(payment.date!)),
        Text(payment.num ?? payment.type.toString().toLowerCase()),
        Text(Utils.amounts(payment.amount)),
        Text(price.toString()),
      ]));
    }).toList();
  }

  List<DataCell> _getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(data)).toList();

  List<DataColumn> _getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();
}

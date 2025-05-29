import 'package:data_table_2/data_table_2.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({
    super.key,
    required this.totalTtc,
    required this.payments,
  });

  final String totalTtc;
  final List<PaymentModel> payments;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: DataTable2(
            headingTextStyle: Theme.of(context).textTheme.titleSmall,
            dataTextStyle: Theme.of(context).textTheme.bodySmall,
            columnSpacing: 4,
            empty: Center(
              child: Text('No payments'),
            ),
            columns: [
              DataColumn2(label: Text('Date')),
              DataColumn2(label: Text('Receipt #'), numeric: true),
              DataColumn2(label: Text('Amount'), numeric: true),
              DataColumn2(
                numeric: true,
                label: Text('Balance'),
              ),
            ],
            rows: _buildDataRow(payments)));
  }

  List<DataRow2> _buildDataRow(List<PaymentModel> payments) {
    List<DataRow2> rows = [];
    int price = int.parse(Utils.amounts(totalTtc));
    for (var payment in payments) {
      price -= Utils.intAmounts(payment.amount);
      rows.add(DataRow2(cells: [
        DataCell(Text(Utils.datePaid(payment.date))),
        DataCell(Text(
          payment.num!,
        )),
        DataCell(Text(
          Utils.amounts(payment.amount),
        )),
        DataCell(Text(
          price.toString(),
        ))
      ]));
    }

    return rows;
  }
}

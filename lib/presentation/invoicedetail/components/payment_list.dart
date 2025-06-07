import 'package:data_table_2/data_table_2.dart';
import 'package:dolirest/infrastructure/dal/models/payment/payment_entity.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';

Widget paymentsList(
    BuildContext context, String totalTtc, List<PaymentEntity> payments) {
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
          rows: _buildDataRow(payments, totalTtc)));
}

List<DataRow2> _buildDataRow(List<PaymentEntity> payments, String totalTtc) {
  List<DataRow2> rows = [];
  int price = int.parse(Utils.amounts(totalTtc));
  for (var payment in payments) {
    price -= Utils.intAmounts(payment.amount);
    rows.add(DataRow2(cells: [
      DataCell(Text(Utils.datePaid(payment.date!))),
      DataCell(Text(
        payment.num,
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

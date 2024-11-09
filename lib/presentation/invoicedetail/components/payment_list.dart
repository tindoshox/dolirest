import 'package:data_table_2/data_table_2.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({
    super.key,
    required this.totalTtc,
    required this.invoiceId,
  });

  final String totalTtc;
  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Get.find<StorageService>().paymentsListenable(),
      builder: (BuildContext context, Box<PaymentModel> box, Widget? child) {
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
                rows: _buildDataRow(box)));
      },
    );
  }

  List<DataRow2> _buildDataRow(Box<PaymentModel> box) {
    List<DataRow2> rows = [];
    final List<PaymentModel> payments = box
        .toMap()
        .values
        .where((p) => p.invoiceId.toString() == invoiceId)
        .toList();
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
}

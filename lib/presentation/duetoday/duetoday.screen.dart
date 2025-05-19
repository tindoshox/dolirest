import 'package:data_table_2/data_table_2.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/duetoday.controller.dart';

class DueTodayScreen extends GetView<DueTodayController> {
  const DueTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildDueToday(context),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Due today"),
      centerTitle: true,
    );
  }

  DataColumn2 buildHeading(
          {required String label,
          void Function(int, bool)? onSort,
          ColumnSize size = ColumnSize.M}) =>
      DataColumn2(
        size: size,
        onSort: onSort,
        label: Text(label),
      );

  DataCell buildCell(String data, {bool softWrap = true}) => DataCell(
        Text(
          data,
          maxLines: 2,
          softWrap: softWrap,
          overflow: TextOverflow.ellipsis,
        ),
      );

  List<DataRow2> buildDataRow() {
    List<DataRow2> rows = <DataRow2>[];
    for (DueTodayModel invoice in controller.dueList) {
      rows.add(DataRow2(
        onSelectChanged: (value) => Get.toNamed(Routes.INVOICEDETAIL,
            arguments: {
              'invoiceId': invoice.invoiceId,
              'customerId': invoice.customerId
            }),
        cells: [
          buildCell(invoice.name),
          buildCell(invoice.dueDate, softWrap: false),
          buildCell(invoice.town),
          buildCell(invoice.address),
        ],
      ));
    }
    return rows;
  }

  buildDueToday(BuildContext context) {
    return DataTable2(
        headingTextStyle: Theme.of(context).textTheme.titleSmall,
        dataTextStyle: Theme.of(context).textTheme.bodySmall,
        showCheckboxColumn: false,
        sortColumnIndex: 2,
        columnSpacing: 3,
        empty: Center(
          child: Text('No invoices due today'),
        ),
        columns: [
          buildHeading(label: 'Customer', size: ColumnSize.M),
          buildHeading(label: 'Due Date', size: ColumnSize.M),
          buildHeading(label: 'Town', size: ColumnSize.S),
          buildHeading(label: 'Address', size: ColumnSize.S),
        ],
        rows: buildDataRow());
  }
}

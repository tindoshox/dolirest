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
      appBar: _buildAppBar(),
      body: _buildDueToday(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Due today"),
      centerTitle: true,
    );
  }

  _buildDueToday() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTable2(
          showCheckboxColumn: false,
          sortColumnIndex: 2,
          columnSpacing: 3,
          columns: [
            _buildHeading(label: 'Customer'),
            _buildHeading(label: 'Due Date'),
            _buildHeading(label: 'Town'),
            _buildHeading(label: 'Address'),
          ],
          rows: _buildDataRow()),
    );
  }

  DataColumn _buildHeading(
          {required String label, void Function(int, bool)? onSort}) =>
      DataColumn(
        onSort: onSort,
        label: Text(label),
      );

  List<DataRow> _buildDataRow() {
    List<DataRow> rows = <DataRow>[];
    for (DueTodayModel invoice in controller.dueList) {
      rows.add(DataRow(
        onSelectChanged: (value) => Get.toNamed(Routes.INVOICEDETAIL,
            arguments: {
              'invoiceId': invoice.invoiceId,
              'customerId': invoice.customerId
            }),
        cells: [
          _buildCell(invoice.name),
          _buildCell(invoice.dueDate),
          _buildCell(invoice.town),
          _buildCell(invoice.address),
        ],
      ));
    }
    return rows;
  }

  DataCell _buildCell(String data) => DataCell(
        Text(
          data,
          maxLines: 2,
          softWrap: true,
        ),
      );
}

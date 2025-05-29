import 'package:data_table_2/data_table_2.dart';
import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/dal/models/invoice/invoice_entity.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/dal/services/local_storage/storage_service.dart';
import '../../utils/utils.dart';
import 'controllers/collections_controller.dart';

class CashflowScreen extends GetView<CashflowController> {
  const CashflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => _buildCashflow(context)),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Today's Collections "),
      centerTitle: true,
    );
  }

  DataTable2 _buildCashflow(BuildContext context) {
    final StorageService storage = controller.storage;

    //Day Cashflow
    List<PaymentModel> dayCashflow = controller.dayCashflow;
    dayCashflow.sort((a, b) => a.date.compareTo(b.date));
    List<int> dayAmounts =
        dayCashflow.map((payment) => Utils.intAmounts(payment.amount)).toList();
    int dayTotal = dayAmounts.isEmpty ? 0 : dayAmounts.reduce((a, b) => a + b);

    DataColumn2 buildHeading(
            {required String label,
            void Function(int, bool)? onSort,
            bool numeric = false,
            ColumnSize size = ColumnSize.M}) =>
        DataColumn2(
          numeric: numeric,
          size: size,
          onSort: onSort,
          label: Text(label),
        );

    DataCell buildCell(String data, {TextAlign? textAlign = TextAlign.start}) =>
        DataCell(
          Text(
            textAlign: textAlign,
            data,
            maxLines: 2,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        );

    List<DataRow2> buildDataRow() {
      List<DataRow2> rows = <DataRow2>[];
      for (PaymentModel payment in dayCashflow) {
        final InvoiceEntity invoice = storage.getInvoice(payment.invoiceId!)!;
        final CustomerEntity customer = storage.getCustomer(invoice.socid!)!;
        rows.add(DataRow2(
          cells: [
            buildCell(invoice.ref ?? 'Unknown Invoice'),
            buildCell(customer.name!),
            buildCell(payment.num!, textAlign: TextAlign.center),
            buildCell(Utils.amounts(payment.amount), textAlign: TextAlign.end),
          ],
        ));
      }
      rows.add(DataRow2(cells: [
        buildCell('Total'),
        buildCell(''),
        buildCell(''),
        buildCell(dayTotal.toString()),
      ]));
      return rows;
    }

    return DataTable2(
        headingTextStyle: Theme.of(context).textTheme.titleSmall,
        dataTextStyle: Theme.of(context).textTheme.bodySmall,
        showCheckboxColumn: false,
        sortColumnIndex: 2,
        columnSpacing: 4,
        empty: Center(
          child: Text('No invoices due today'),
        ),
        columns: [
          buildHeading(label: 'Invoice'),
          buildHeading(label: 'Customer', size: ColumnSize.L),
          buildHeading(label: 'Receipt', size: ColumnSize.S),
          buildHeading(label: 'Amount', size: ColumnSize.S, numeric: true),
        ],
        rows: buildDataRow());
  }
}

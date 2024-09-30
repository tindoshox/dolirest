import 'package:dolirest/infrastructure/dal/models/invoice_model.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../infrastructure/dal/services/storage.dart';
import '../../utils/utils.dart';
import 'controllers/collections_controller.dart';

class CashflowScreen extends GetView<CashflowController> {
  const CashflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildCashflow());
  }
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text("Cashflow"),
    centerTitle: true,
  );
}

_buildCashflow() {
  return Align(
    alignment: Alignment.center,
    child: ValueListenableBuilder(
        valueListenable: Storage.payments.listenable(),
        builder: (context, box, widget) {
          var list = box.values.toList();
          var flat = list.expand((i) => i).toList();

          //Day Cashflow
          List<PaymentModel> dayCashflow = flat
              .where((f) =>
                  Utils.datePaid(f.date) == Utils.datePaid(DateTime.now()))
              .cast<PaymentModel>()
              .toList();
          List<int> dayAmounts = dayCashflow
              .map((payment) => Utils.intAmounts(payment.amount))
              .toList();
          int dayTotal =
              dayAmounts.isEmpty ? 0 : dayAmounts.reduce((a, b) => a + b);
          return dayCashflow.isEmpty
              ? const ListTile(
                  title: Text('No payments found', textAlign: TextAlign.center),
                )
              : ListView.separated(
                  itemCount: dayCashflow.length + 1,
                  itemBuilder: (context, index) {
                    if (index < dayCashflow.length) {
                      PaymentModel payment = dayCashflow[index];
                      InvoiceModel invoice =
                          Storage.invoices.get(payment.invoiceId.toString()) ??
                              InvoiceModel();
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(invoice.nom ?? ""),
                              Text(Utils.datePaid(payment.date!)),
                              Text(payment.num),
                              Text(Utils.amounts(payment.amount)),
                            ]),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Total: '),
                            Text(dayTotal.toString())
                          ],
                        ),
                      );
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(),
                );
        }),
  );
}

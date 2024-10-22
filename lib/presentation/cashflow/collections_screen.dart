import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/dal/services/storage/storage.dart';
import '../../utils/utils.dart';
import 'controllers/collections_controller.dart';

class CashflowScreen extends GetView<CashflowController> {
  const CashflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildCashflow(storageController: controller.storageController));
  }
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text("Daily Cashflow"),
    centerTitle: true,
  );
}

_buildCashflow({required StorageController storageController}) {
  return Align(
    alignment: Alignment.center,
    child: ValueListenableBuilder(
        valueListenable: storageController.paymentsListenable(),
        builder: (context, box, widget) {
          var list = box.values.toList();

          //Day Cashflow
          List<PaymentModel> dayCashflow = list
              .where((f) =>
                  Utils.datePaid(f.date!) == Utils.datePaid(DateTime.now()))
              .cast<PaymentModel>()
              .toList();
          dayCashflow.sort((a, b) => a.date!.compareTo(b.date!));
          List<int> dayAmounts = dayCashflow
              .map((payment) => Utils.intAmounts(payment.amount))
              .toList();
          int dayTotal =
              dayAmounts.isEmpty ? 0 : dayAmounts.reduce((a, b) => a + b);
          if (dayCashflow.isEmpty) {
            return const Center(
              child: Text('No payments', textAlign: TextAlign.center),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: _StickyHeaderDelegate(
                      child: Container(
                        alignment: Alignment.center,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            _buildCell(
                                flex: 6,
                                mainAxisAlignment: MainAxisAlignment.start,
                                text: 'Customer'),
                            _buildCell(
                              text: 'Date',
                            ),
                            _buildCell(text: 'Receipt #'),
                            _buildCell(text: 'Amount')
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final payment = dayCashflow[index];
                      final invoice =
                          storageController.getInvoice(payment.invoiceId);

                      return Column(children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            _buildCell(
                              flex: 6,
                              mainAxisAlignment: MainAxisAlignment.start,
                              text: invoice!.nom,
                            ),
                            _buildCell(text: Utils.datePaid(payment.date!)),
                            _buildCell(text: payment.num),
                            _buildCell(text: Utils.amounts(payment.amount))
                          ],
                        ),
                        const Divider(
                          thickness: .05,
                        ),
                      ]);
                    }, childCount: dayCashflow.length),
                  ),
                  SliverFillRemaining(
                    child: Text(
                      'Total:$dayTotal',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }),
  );
}

Flexible _buildCell({
  int flex = 2,
  String text = 'Heading',
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  TextStyle? style = const TextStyle(fontSize: 12),
}) {
  return Flexible(
    flex: flex,
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Text(
          text,
          style: style,
        ),
      ],
    ),
  );
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 40; // Adjust this value according to your needs

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}

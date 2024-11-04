import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../infrastructure/dal/services/local_storage/local_storage.dart';
import '../../utils/utils.dart';
import 'controllers/collections_controller.dart';

class CashflowScreen extends GetView<CashflowController> {
  const CashflowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildCashflow(storage: controller.storage));
  }
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text("Today's Collections "),
    centerTitle: true,
  );
}

_buildCashflow({required StorageController storage}) {
  return Align(
    alignment: Alignment.center,
    child: ValueListenableBuilder(
        valueListenable: storage.paymentsListenable(),
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
                                text: 'Invoice',
                                mainAxisAlignment: MainAxisAlignment.start,
                                flex: 3),
                            _buildCell(
                                flex: 5,
                                mainAxisAlignment: MainAxisAlignment.start,
                                text: 'Customer'),
                            _buildCell(text: 'Receipt #'),
                            _buildCell(
                                text: 'Amount', textAlign: TextAlign.right)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final payment = dayCashflow[index];
                      final invoice = storage.getInvoice(payment.invoiceId);
                      final customer = storage.getCustomer(invoice?.socid);

                      return Column(children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            _buildCell(
                              text: invoice!.ref,
                              mainAxisAlignment: MainAxisAlignment.start,
                              flex: 3,
                            ),
                            _buildCell(
                              flex: 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              text: customer?.name,
                            ),
                            _buildCell(
                              text: payment.num,
                            ),
                            _buildCell(
                              text: Utils.amounts(payment.amount),
                              textAlign: TextAlign.right,
                            )
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
                      textAlign: TextAlign.right,
                      'Total: $dayTotal',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
  TextAlign? textAlign,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  TextStyle? style = const TextStyle(fontSize: 12),
}) {
  return Flexible(
    flex: flex,
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Expanded(
          child: Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
            textAlign: textAlign,
          ),
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

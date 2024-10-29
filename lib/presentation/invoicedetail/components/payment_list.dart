import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/infrastructure/dal/services/local_storage/local_storage.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      valueListenable: Get.find<StorageController>().paymentsListenable(),
      builder: (BuildContext context, Box<PaymentModel> box, Widget? child) {
        final List<PaymentModel> payments = box
            .toMap()
            .values
            .toList()
            .where((p) => p.invoiceId.toString() == invoiceId)
            .toList();
        debugPrint(payments.length.toString());
        int price = int.parse(Utils.amounts(totalTtc));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: Container(
                    alignment: Alignment.center,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        _buildCell(
                            text: 'Date',
                            mainAxisAlignment: MainAxisAlignment.start),
                        _buildCell(text: 'Receipt'),
                        _buildCell(text: 'Amt'),
                        _buildCell(
                            text: 'Balance',
                            mainAxisAlignment: MainAxisAlignment.end),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final payment = payments[index];
                    price -= Utils.intAmounts(payment.amount);

                    return payments.isEmpty
                        ? const ListTile(
                            title: Text('No Payments'),
                            titleAlignment: ListTileTitleAlignment.center,
                          )
                        : Column(
                            children: [
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  _buildCell(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      text: Utils.datePaid(payment.date!),
                                      style: null),
                                  _buildCell(
                                      text: payment.num ??
                                          payment.type.toString().toLowerCase(),
                                      style: null),
                                  _buildCell(
                                      text: Utils.amounts(payment.amount),
                                      style: null),
                                  _buildCell(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      text: price.toString(),
                                      style: null)
                                ],
                              ),
                              const Divider(
                                thickness: 0.5,
                              )
                            ],
                          );
                  },
                  childCount: payments.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Flexible _buildCell(
      {String text = 'Heading',
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
      TextStyle? style = const TextStyle(fontSize: 20)}) {
    return Flexible(
      flex: 2,
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

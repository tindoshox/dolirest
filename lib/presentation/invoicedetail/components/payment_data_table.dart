import 'package:dolirest/infrastructure/dal/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:dolirest/infrastructure/dal/models/payment_model.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PaymentsDataTable extends StatelessWidget {
  const PaymentsDataTable({
    super.key,
    required this.totalTtc,
    required this.invoiceId,
  });

  final String totalTtc;
  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Storage.payments.listenable(),
      builder: (BuildContext context, Box<List> box, Widget? child) {
        final List<PaymentModel> payments = box.get(invoiceId,
            defaultValue: <PaymentModel>[])!.cast<PaymentModel>();
        int price = int.parse(Utils.amounts(totalTtc));
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  _buildCell(
                      text: 'Date', mainAxisAlignment: MainAxisAlignment.start),
                  _buildCell(text: 'Receipt'),
                  _buildCell(text: 'Amount'),
                  _buildCell(
                      text: 'Balance',
                      mainAxisAlignment: MainAxisAlignment.end),
                ],
              ),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var payment = payments[index];
                  price -= Utils.intAmounts(payment.amount);

                  return payments.isEmpty
                      ? const ListTile(
                          title: Text('No Payments'),
                          titleAlignment: ListTileTitleAlignment.center,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 3),
                          child: Column(
                            children: [
                              Row(
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
                          ),
                        );
                },
                childCount: payments.length,
              ),
            ),
          ],
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

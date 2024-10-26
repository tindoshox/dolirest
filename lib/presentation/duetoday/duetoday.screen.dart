import 'package:dolirest/infrastructure/dal/services/local_storage/storage.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/duetoday.controller.dart';

class DuetodayScreen extends GetView<DuetodayController> {
  const DuetodayScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final StorageController storageController = Get.find();
    return Scaffold(
        appBar: _buildAppBar(),
        body: _buildDueflow(storageController: storageController));
  }
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text("Due today"),
    centerTitle: true,
  );
}

_buildDueflow({required StorageController storageController}) {
  return Align(
    alignment: Alignment.center,
    child: ValueListenableBuilder(
        valueListenable: storageController.invoicesListenable(),
        builder: (context, box, widget) {
          var dueToday = box.values
              .where((i) => DateUtils.isSameDay(
                  Utils.intToDateTime(i.dateLimReglement), DateTime.now()))
              .toList();
          //Day Cashflow

          if (dueToday.isEmpty) {
            return const Center(
              child: Text('No invoice due today', textAlign: TextAlign.center),
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
                                flex: 4,
                                mainAxisAlignment: MainAxisAlignment.start,
                                text: 'Customer'),
                            _buildCell(
                              mainAxisAlignment: MainAxisAlignment.start,
                              text: 'Due Date',
                              flex: 1,
                            ),
                            _buildCell(
                                text: 'Area', textAlign: TextAlign.right),
                            _buildCell(
                              text: 'Sub',
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final invoice = dueToday[index];
                      final customer =
                          storageController.getCustomer(invoice.socid);

                      return Column(children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            _buildCell(
                              flex: 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              text: customer?.name,
                            ),
                            _buildCell(
                                mainAxisAlignment: MainAxisAlignment.start,
                                text: Utils.intToDMY(invoice.dateLimReglement),
                                flex: 1),
                            _buildCell(
                              text: customer?.town ?? '',
                              textAlign: TextAlign.right,
                            ),
                            _buildCell(
                              text: customer?.address ?? '',
                              mainAxisAlignment: MainAxisAlignment.start,
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: .05,
                        ),
                      ]);
                    }, childCount: dueToday.length),
                  ),
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

import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/utils/utils.dart' show Utils;
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

  buildDueToday(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return Obx(() {
      var invoices = controller.dueToday;
      invoices.removeWhere((d) => DateUtils.isSameMonth(
          Utils.intToDateTime(d.dateLimReglement),
          DateTime.now().add(Duration(days: 30))));

      if (invoices.isEmpty) {
        return Center(
          child: Text('Nothing to see here'),
        );
      } else {
        return ListView.builder(
          controller: scrollController,
          itemCount: invoices.length + 1,
          itemBuilder: (context, index) {
            if (index < invoices.length) {
              var invoice = invoices[index];
              var customer = controller.customers
                  .firstWhere((c) => c.customerId == invoice.socid);

              return Card(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.INVOICEDETAIL, arguments: {
                      'entityId': invoice.id,
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        textBox(context, customer.name, flex: 2),
                        SizedBox(
                          width: 2,
                        ),
                        textBox(
                            context, Utils.intToDMY(invoice.dateLimReglement),
                            textAlign: TextAlign.center),
                        SizedBox(
                          width: 2,
                        ),
                        textBox(
                          context,
                          customer.town,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        textBox(context, customer.address),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: Text('End of list!')),
              );
            }
          },
        );
      }
    });
  }

  Widget textBox(BuildContext context, String text,
      {int flex = 1, TextAlign textAlign = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
      ),
    );
  }
}

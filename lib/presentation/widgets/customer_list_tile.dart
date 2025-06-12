import 'package:dolirest/infrastructure/dal/models/customer/customer_entity.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';

Card buildCustomerListTile(
    {required CustomerEntity customer,
    required BuildContext context,
    bool noInvoice = false,
    void Function()? onDeletePressed}) {
  return Card(
    child: ListTile(
      onTap: () => Get.toNamed(Routes.CUSTOMERDETAIL, arguments: {
        'entityId': customer.id,
      }),
      leading: Initicon(
        text: customer.name,
        size: 30,
      ),
      trailing: noInvoice == false
          ? null
          : IconButton(onPressed: onDeletePressed, icon: Icon(Icons.delete)),
      title: Row(
        children: [
          Flexible(
            child: Text(
              customer.name,
              style: Theme.of(context).textTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Flexible(
            child: Text(
              '${customer.address} ${customer.town}'.trim(),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ),
  );
}

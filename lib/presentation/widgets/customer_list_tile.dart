import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:get/get.dart';

Card buildCustomerListTile(CustomerModel customer, BuildContext context) {
  return Card(
    child: ListTile(
      onTap: () => Get.toNamed(Routes.CUSTOMERDETAIL, arguments: {
        'customerId': customer.id.toString(),
      }),
      leading: Initicon(
        text: customer.name,
        size: 30,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              customer.name!,
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
              '${customer.address ?? ''} ${customer.town ?? ''}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    ),
  );
}

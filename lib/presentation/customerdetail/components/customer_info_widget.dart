import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dolirest/infrastructure/dal/models/customer_by_id_model.dart';
import 'package:dolirest/infrastructure/navigation/routes.dart';
import 'package:dolirest/presentation/widgets/custom_action_button.dart';
import 'package:dolirest/utils/utils.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({super.key, required this.customer});
  final ThirdPartyById customer;
  @override
  Widget build(BuildContext context) {
    var children = [
      CustomerInfoRow(
        title: customer.name.toString(),
        leading: const Icon(Icons.person_outline),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        subtitle: Text(customer.codeClient.toString()),
      ),
      CustomerInfoRow(
        title: '${customer.address} ${customer.town}',
        leading: const Icon(Icons.location_city_outlined),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      if (customer.phone != null && customer.phone.toString().trim().isNotEmpty)
        CustomerInfoRow(
          onTap: () => makePhoneCall(customer.phone.toString().trim()),
          title: customer.phone,
          leading: const Icon(Icons.phone_android),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      if (customer.fax != null && customer.fax.toString().trim().isNotEmpty)
        CustomerInfoRow(
          onTap: () => makePhoneCall(customer.fax.toString().trim()),
          title: customer.fax,
          leading: const Icon(Icons.phone_android_outlined),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomActionButton(
              buttonText: 'Edit',
              onTap: () => Get.offAndToNamed(Routes.EDITCUSTOMER,
                  arguments: {'customerId': customer.id}),
            ),
            CustomActionButton(
                buttonText: 'New Invoice',
                onTap: () => Get.offAndToNamed(Routes.CREATEINVOICE,
                    arguments: {'customerId': customer.id, 'fromhome': false})),
          ],
        ),
      ),
    ];
    return ListView.separated(
        itemBuilder: (context, index) {
          var child = children[index];
          return child;
        },
        separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
        itemCount: children.length);
  }
}

class CustomerInfoRow extends StatelessWidget {
  const CustomerInfoRow(
      {super.key,
      required this.title,
      this.style,
      this.leading,
      this.subtitle,
      this.onTap});
  final String title;

  final TextStyle? style;
  final Widget? leading;
  final Widget? subtitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: onTap,
        title: Text(title.trim(), style: style),
        subtitle: subtitle,
        leading: leading,
      ),
    );
  }
}

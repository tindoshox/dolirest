import 'package:dolirest/infrastructure/dal/models/customer_model.dart';
import 'package:dolirest/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

class CustomerInfoWidget extends StatelessWidget {
  const CustomerInfoWidget({super.key, required this.customer});
  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      _buildCustomerInfoRow(
        title: customer.name,
        leading: Initicon(
          text: customer.name,
          size: 30,
        ),
        style: Theme.of(context).textTheme.titleSmall,
        subtitle: Text(
          customer.codeClient,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
      _buildCustomerInfoRow(
        title: '${customer.town} ${customer.address}',
        leading: const Icon(
          Icons.location_city_outlined,
          color: Colors.greenAccent,
        ),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      if (customer.phone?.trim().isNotEmpty ?? false)
        _buildCustomerInfoRow(
          onTap: () => Utils.makePhoneCall(customer.phone!.trim()),
          title: customer.phone!,
          leading: const Icon(
            Icons.phone_android,
            color: Colors.blueAccent,
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      if (customer.fax?.trim().isNotEmpty ?? false)
        _buildCustomerInfoRow(
          onTap: () => Utils.makePhoneCall(customer.fax!.trim()),
          title: customer.fax!,
          leading: const Icon(
            Icons.phone_android_outlined,
            color: Colors.blueGrey,
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
    ];

    return ListView.separated(
      itemBuilder: (context, index) => children[index],
      separatorBuilder: (context, index) =>
          const Divider(color: Colors.grey, thickness: 1),
      itemCount: children.length,
    );
  }

  Widget _buildCustomerInfoRow({
    required String title,
    TextStyle? style,
    Widget? leading,
    Widget? subtitle,
    Function()? onTap,
  }) {
    return CustomerInfoRow(
      title: title,
      style: style,
      leading: leading,
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}

class CustomerInfoRow extends StatelessWidget {
  const CustomerInfoRow({
    super.key,
    required this.title,
    this.style,
    this.leading,
    this.subtitle,
    this.onTap,
  });

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
        title: Row(
          children: [
            Flexible(
              child: Text(
                title.trim(),
                style: style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: subtitle,
        leading: leading,
      ),
    );
  }
}

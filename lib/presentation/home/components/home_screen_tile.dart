import 'package:flutter/material.dart';

class HomeScreenTile extends StatelessWidget {
  const HomeScreenTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.color,
  });

  final String title;
  final IconData icon;
  final void Function() onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 25,
      ),
      title: Text(
        title,
        maxLines: 2,
        softWrap: true,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}

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
    return InkWell(
        onTap: onTap,
        child: Card(
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
              )
            ],
          ),
        ));
  }
}

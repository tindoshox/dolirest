import 'package:dolirest/infrastructure/dal/services/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget _makeIcon(String text, IconData icon, Color color) {
  return Tooltip(
      message: text,
      child: SizedBox(
          width: 40,
          height: null,
          child: Icon(
            icon,
            size: 24,
            color: color,
          )));
}

Widget getStatusIcon() {
  if (!Get.find<NetworkController>().connected.value) {
    return _makeIcon('No connection', Icons.cloud_off_outlined, Colors.red);
  } else {
    return _makeIcon('Connected', Icons.cloud_done_outlined, Colors.lightGreen);
  }
}

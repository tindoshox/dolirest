import 'package:dolirest/infrastructure/dal/services/controllers/network_controller.dart';
import 'package:dolirest/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

Widget _makeIcon(
    {required String text,
    required IconData icon,
    required Color color,
    void Function()? onPressed}) {
  return Tooltip(
      message: text,
      child: SizedBox(
          width: 40,
          height: null,
          child: IconButton(
            iconSize: 24,
            color: color,
            onPressed: onPressed,
            icon: Icon(icon),
          )));
}

Widget getStatusIcon({void Function()? onPressed, bool refreshing = false}) {
  if (refreshing) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: const SpinKitThreeInOut(
        color: Colors.blueAccent,
        size: 10,
      ),
    );
  } else {
    if (!Get.find<NetworkController>().connected.value) {
      return _makeIcon(
          text: 'No connection',
          icon: Icons.cloud_off_outlined,
          color: Colors.red,
          onPressed: () => SnackBarHelper.networkSnackbar());
    } else {
      return _makeIcon(
          text: 'Connected',
          icon: Icons.cloud_done_outlined,
          color: Colors.lightGreen,
          onPressed: onPressed ??
              () => SnackBarHelper.successSnackbar(message: 'Connected'));
    }
  }
}

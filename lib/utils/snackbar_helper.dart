import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A helper class for showing snackbars.
class SnackBarHelper {
  /// Shows a snackbar with customizable options.
  ///
  static void showSnackbar(
      {String? title,
      String? message,
      IconData icon = Icons.info,
      Color backgroundColor = Colors.black,
      Duration duration = const Duration(seconds: 5),
      Color textColor = Colors.white,
      double fontSize = 15}) {
    Get.rawSnackbar(
      snackStyle: SnackStyle.GROUNDED,
      padding: const EdgeInsets.symmetric(vertical: 5),
      icon: Icon(icon),
      duration: duration,
      backgroundColor: backgroundColor,
      title: title,
      messageText: Text(
        message ?? '',
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
    );
  }

  /// Shows a success snackbar.
  ///
  static void successSnackbar({
    String? title,
    String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    showSnackbar(
      duration: duration,
      title: title,
      message: message ?? 'Operation was successful.',
      icon: Icons.thumb_up_off_alt_sharp,
      backgroundColor: const Color.fromARGB(255, 33, 78, 7),
    );
  }

  /// Shows an error snackbar.
  ///
  static void errorSnackbar({
    String? title,
    String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    showSnackbar(
      duration: duration,
      title: title,
      message: message ?? 'An error occurred.',
      icon: Icons.error,
      backgroundColor: const Color.fromARGB(255, 110, 13, 13),
    );
  }

  static void networkSnackbar({
    String? title,
    String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    showSnackbar(
      duration: duration,
      title: title,
      message: message ?? 'No connection to server',
      icon: Icons.network_locked,
      backgroundColor: const Color.fromARGB(255, 255, 7, 7),
    );
  }
}

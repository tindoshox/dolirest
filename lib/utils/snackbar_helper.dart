import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A helper class for showing snackbars.
class SnackBarHelper {
  /// Shows a success snackbar.
  ///
  /// The [title] and [message] parameters are optional. If provided, they will
  /// be displayed in the snackbar. The [statusCode] parameter is optional and
  /// can be used to display the status code in the snackbar.

  static void successSnackbar(
      {String title = '', String? message, String? statusCode}) {
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 191, 255, 153),
      title: title,
      messageText: ListTile(
        title: Text(message ?? 'Operation Successful.'),
        subtitle: statusCode == null ? null : Text('Status code: $statusCode'),
      ),
    ));
  }

  /// Shows an error snackbar.
  ///
  /// The [title] and [message] parameters are optional. If provided, they will
  /// be displayed in the snackbar. The [statusCode] parameter is optional and
  /// can be used to display the status code in the snackbar.

  static void errorSnackbar(
      {String title = '', String? message, String? statusCode}) {
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 255, 78, 78),
      title: title,
      messageText: ListTile(
        title: Text(message ?? 'Unknown error occured.'),
        subtitle: statusCode == null ? null : Text('Status code: $statusCode'),
      ),
    ));
  }
}

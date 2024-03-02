import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A helper class for showing snackbars.
class SnackBarHelper {
  /// Shows a success snackbar.
  ///

  static void successSnackbar(
      {String title = 'Sucess', String? message, String? statusCode}) {
    Get.showSnackbar(GetSnackBar(
      icon: const Icon(Icons.thumb_up_off_alt_sharp),
      duration: const Duration(seconds: 2),
      //snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 33, 78, 7),
      title: title,
      messageText: Text(message ?? 'Operation was successful.'),
    ));
  }

  /// Shows an error snackbar.

  static void errorSnackbar(
      {String title = 'Error', String? message, String? statusCode}) {
    Get.showSnackbar(GetSnackBar(
      icon: const Icon(Icons.error),
      duration: const Duration(seconds: 2),
      //snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 110, 13, 13),
      title: title,
      messageText: Text(message ?? 'An error occured.'),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A helper class for showing dialogs.
class DialogHelper {
  /// Shows a loading dialog with an optional message.
  ///
  /// The dialog will automatically be dismissed when the user dismisses the dialog or presses the back button.
  static void showLoading([String? message]) {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// A [CircularProgressIndicator] to indicate that the application is busy.
              const CircularProgressIndicator(),
              const SizedBox(height: 8),

              /// A [Text] widget that displays a message indicating that the application is busy.
              Text(message ?? 'Loading...'),
            ],
          ),
        ),
      ),
    );
  }

  /// Hides the loading dialog if it is currently displayed.
  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}

import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper {
  static final RxString _loadingMessage = 'Loading...'.obs;

  /// Shows a loading dialog with a reactive message.
  static void showLoading([String? message]) {
    _loadingMessage.value = message ?? 'Loading...';

    if (Get.isDialogOpen != true) {
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          backgroundColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LoadingIndicator(),
                const SizedBox(height: 8),
                Obx(() => Text(_loadingMessage.value)),
              ],
            ),
          ),
        ),
      );
    }
  }

  /// Updates the message shown in the loading dialog.
  static void updateMessage(String message) {
    _loadingMessage.value = message;
  }

  /// Hides the loading dialog if it is currently displayed.
  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}

import 'package:dolirest/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A helper class for showing dialogs.
class LoadingOverlay {
  /// Shows a loading overlay with an optional message.
  ///
  /// The overlay will automatically be dismissed when the user dismisses the overlay or presses the back button.
  static void showLoading([String? message]) {
    if (Get.isOverlaysClosed) {
      Get.showOverlay(
        opacity: 0,
        opacityColor: Colors.transparent,
        loadingWidget: Column(
          children: [
            const LoadingIndicator(),
            if (message != null) Text(message)
          ],
        ),
        asyncFunction: () async {
          return true;
        },
      );
    }
  }

  /// Hides the loading overlay if it is currently displayed.
  static void hideLoading() {
    if (Get.isOverlaysOpen) {
      Get.back();
    }
  }
}

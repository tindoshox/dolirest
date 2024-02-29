import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

/// A custom action button that can be used in the application.
///
/// This button can be used to trigger an action, such as saving or deleting
/// data. It provides a clean and consistent look throughout the application.
///
/// The button can be customized by providing the text, color, and size. The
/// size can be adjusted to fit the needs of the application.
///
/// The button also provides a controller, which can be used to control the
/// state of the button.
class CustomActionButton extends StatelessWidget {
  /// Creates a custom action button.
  ///
  /// The [controller] parameter can be used to control the state of the button.
  /// The [buttonText] parameter specifies the text that will be displayed on
  /// the button. The [buttonColor] parameter specifies the color of the button.
  /// The [onTap] parameter specifies the function to be called when the button
  /// is tapped. The [maximumSize] and [minimumSize] parameters specify the
  /// maximum and minimum size of the button, respectively.
  const CustomActionButton({
    super.key,
    this.controller,
    required this.buttonText,
    this.buttonColor,
    this.onTap,
    this.maximumSize = const Size(150, 50),
    this.minimumSize = const Size(150, 50),
  });

  /// The controller for the button.
  final GetxController? controller;

  /// The text that will be displayed on the button.
  final String buttonText;

  /// The color of the button.
  final Color? buttonColor;

  /// The function to be called when the button is tapped.
  final void Function()? onTap;

  /// The maximum size of the button.
  final Size? maximumSize;

  /// The minimum size of the button.
  final Size? minimumSize;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: buttonColor,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        shape: const StadiumBorder(),
        side: BorderSide(
          width: 2,
          color: buttonColor ?? Theme.of(context).colorScheme.onBackground,
        ),
      ),
      child: Text(
        buttonText,
      ),
    );
  }
}

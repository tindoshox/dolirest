import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  const DialogActionButton(
      {super.key, this.onPressed, required this.buttonText, this.buttonColor});
  final void Function()? onPressed;
  final String buttonText;
  final Color? buttonColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        maximumSize: const Size(100, 40),
        minimumSize: const Size(100, 40),
        side: BorderSide(
          width: 1,
          color: buttonColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      child: Text(buttonText),
    );
  }
}

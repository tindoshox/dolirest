import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom form field that wraps a [FormBuilderTextField].
///
/// This widget is used to create a custom form field that can be used with
/// [FormBuilder]. It wraps a [FormBuilderTextField] and provides additional
/// functionality, such as adding a prefix icon, suffix, hint text, and error
/// messages.
class CustomFormField extends StatelessWidget {
  /// Creates a custom form field.
  ///
  /// The [name] argument is used to identify the field in the form. The
  /// [controller] argument is used to control the text input. The other
  /// arguments provide additional styling and functionality for the field.
  const CustomFormField({
    super.key,
    required this.name,
    this.initialValue,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.validator,
    this.textCapitalization = TextCapitalization.characters,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.autocorrect = true,
    this.autofocus = false,
    this.labelText,
    this.obscureText = false,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.onTap,
    this.onEditingComplete,
    this.prefixText,
    this.suffix,
    this.prefixIcon,
    this.onSaved,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.maxLines,
    this.minLines,
    this.onFieldSubmitted,
    this.border,
    this.errorBorder,
  });

  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final String name;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;
  final bool autofocus;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool obscureText;
  final Function()? onTap;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final Function(String?)? onSaved;
  final Function(String?)? onChanged;
  final Function()? onEditingComplete;
  final TextInputAction textInputAction;
  final int? minLines;
  final int? maxLines;
  final InputBorder? border;
  final InputBorder? errorBorder;
  final Function(String?)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: initialValue,
        focusNode: focusNode,
        autofocus: autofocus,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        enableInteractiveSelection: enableInteractiveSelection,
        onTap: onTap,
        inputFormatters: inputFormatters,
        controller: controller,
        onSaved: onSaved,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: Theme.of(context).inputDecorationTheme.border,
          errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          suffix: suffix,
          hintText: hintText,
          labelText: labelText,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final int maxLength;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextInputAction textInputAction;
  final bool enabled;
  final bool showCounter;
  final bool multiline;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final Color backgroundColor;
  final TextEditingController? controller;

  CustomTextFormField({
    required this.hint,
    required this.maxLength,
    required this.validator,
    required this.onSaved,
    required this.textInputAction,
    this.enabled = true,
    this.showCounter = false,
    this.multiline = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.backgroundColor = const Color.fromRGBO(66, 66, 66, 1),
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          // fillColor: backgroundColor,
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
          counterText: showCounter ? null : '',
          errorStyle: TextStyle(
            color: Theme.of(context).errorColor,
          ),
          errorMaxLines: 2,
          // suffixIcon: suffixIcon
        ),
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: multiline ? null : 1,
        minLines: multiline ? 3 : 1,
        validator: validator,
        onSaved: onSaved,
        controller: controller,
        buildCounter: (
          _, {
          required currentLength,
          maxLength,
          required isFocused,
        }) =>
            Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                currentLength.toString() + "/" + maxLength.toString(),
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class MyTextField extends StatelessWidget {
  final String? hintText, labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final Color? fillColor;
  final bool? filled;
  final bool enabled;
  final InputBorder? inputBorder;

  const MyTextField({
    Key? key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.suffix,
    this.onChanged,
    this.enabled = true,
    this.fillColor,
    this.filled,
    this.inputBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
          focusedBorder: inputBorder,
          border: inputBorder,
          fillColor: fillColor,
          filled: filled,
          labelText: labelText,
          hintText: hintText,
          suffix: suffix,
          enabled: enabled,
          labelStyle: headLineStyle.copyWith(color: amberColor)),
    );
  }
}

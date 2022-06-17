import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class MyButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final double? width, height;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  const MyButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: headLineStyle.copyWith(
            color: textColor ?? Colors.black, fontSize: fontSize),
      ),
      style: ButtonStyle(
        minimumSize: width == null && height == null
            ? null
            : MaterialStateProperty.resolveWith(
                (states) => Size(width!, height!)),
        backgroundColor:
            MaterialStateColor.resolveWith((states) => color ?? amberColor),
      ),
    );
  }
}

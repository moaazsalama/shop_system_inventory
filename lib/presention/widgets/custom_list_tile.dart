import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/fonts.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  const CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      textColor: amberColor,
      title: Text(
        title,
        style: headLineStyle,
      ),
      trailing: Icon(
        icon,
        // color: amberColor,
        size: 26,
      ),
      style: ListTileStyle.drawer,
    );
  }
}

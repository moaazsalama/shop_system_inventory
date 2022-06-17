import 'package:flutter/material.dart';

import '../../constants/fonts.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  const MyAppBar({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title ?? 'مفروشات تك',
        style: titleStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 30),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

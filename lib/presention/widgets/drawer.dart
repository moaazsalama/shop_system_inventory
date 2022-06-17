import 'package:flutter/material.dart';
import 'package:mafroshat_tech/constants/strings.dart';

import 'custom_list_tile.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        CustomListTile(
          icon: Icons.home,
          title: "الصفحة الرئيسية",
          onTap: () {
            Navigator.pushReplacementNamed(context, homeScreen);
          },
        ),
        CustomListTile(
          icon: Icons.receipt_long_sharp,
          title: "الفواتير",
          onTap: () {
            Navigator.pushReplacementNamed(context, orderScreen);
          },
        ),
        CustomListTile(
          icon: Icons.local_grocery_store,
          title: "المنتجات",
          onTap: () {
            Navigator.pushReplacementNamed(context, productScreen);
          },
        ),
        CustomListTile(
          icon: Icons.category,
          title: "الأصناف",
          onTap: () {
            Navigator.pushReplacementNamed(context, categoryScreen);
          },
        ),
      ]),
    );
  }
}

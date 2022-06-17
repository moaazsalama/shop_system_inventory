import 'package:flutter/material.dart';
import 'package:mafroshat_tech/constants/strings.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';
import 'package:mafroshat_tech/presention/screens/category/add_category.dart';
import 'package:mafroshat_tech/presention/screens/category/category_screen.dart';
import 'package:mafroshat_tech/presention/screens/home_screen.dart';
import 'package:mafroshat_tech/presention/screens/order/add_order.dart';
import 'package:mafroshat_tech/presention/screens/order/order_screen.dart';
import 'package:mafroshat_tech/presention/screens/producct/add_product.dart';
import 'package:mafroshat_tech/presention/screens/producct/product_screen.dart';

class AppRouter {
  Route onGenrateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case productScreen:
        return MaterialPageRoute(
          builder: (context) => const ProductScreen(),
        );
      case addProductScreen:
        var arguments = routeSettings.arguments as bool;

        return MaterialPageRoute(
          builder: (context) => AddProductScreen(edit: arguments),
        );
      case categoryScreen:
        return MaterialPageRoute(
          builder: (context) => const CategoryScreen(),
        );
      case addCategoryScreen:
        var arguments = routeSettings.arguments as bool;
        return MaterialPageRoute(
          builder: (context) => AddCategoryScreen(edit: arguments),
        );
      case orderScreen:
        return MaterialPageRoute(
          builder: (context) => const OrderScreen(),
        );
      case addOrderScreen:
        var arguments = routeSettings.arguments as OrderItem;

        return MaterialPageRoute(
          builder: (context) => EditOrderItemScreen(edit: arguments),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mafroshat_tech/app_router.dart';
import 'package:mafroshat_tech/business_logic/cart/cart_cubit.dart';
import 'package:mafroshat_tech/business_logic/category/category_cubit.dart';
import 'package:mafroshat_tech/business_logic/pdf/pdf_cubit.dart';

import 'package:mafroshat_tech/business_logic/product/product_cubit.dart';
import 'package:mafroshat_tech/business_logic/order/order_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/data/database/datatbase.dart';

import 'business_logic/home/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Databasae.init();

  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);
  final AppRouter appRouter;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit()..getProducts(),
        ),
        BlocProvider<PdfCubit>(
          create: (context) => PdfCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit()..getProducts(),
        ),
        BlocProvider<CategoryCubit>(
          create: (context) => CategoryCubit()..getCategories(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.onGenrateRoutes,
        darkTheme: ThemeData.dark()
            .copyWith(accentColor: amberColor, buttonColor: amberColor),
        locale: const Locale('ar'),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        themeMode: ThemeMode.dark,
        //  theme: ThemeData(fontFamily: "Cario"),
      ),
    );
  }
}

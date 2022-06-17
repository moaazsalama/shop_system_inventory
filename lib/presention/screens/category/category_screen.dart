import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/category/category_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/constants/strings.dart';
import 'package:mafroshat_tech/presention/widgets/drawer.dart';
import 'package:mafroshat_tech/presention/widgets/myapp_bar.dart';

import '../../widgets/mybutton.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          BlocBuilder<CategoryCubit, CategoryState>(
            builder: (context, state) {
              var cubit = CategoryCubit.getCubit(context);
              return SizedBox(
                height: MediaQuery.of(context).size.height * .6,
                child: DefaultTextStyle(
                  style: bodyStyle,
                  child: Table(
                    border: TableBorder.all(color: amberColor, width: 2),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                            child: Text(
                              'الكود',
                              textAlign: TextAlign.center,
                              style: bodyStyle.copyWith(
                                  fontSize: 20, color: amberColor),
                            ),
                          ),
                          Text(
                            'اسم الصنف ',
                            style: bodyStyle.copyWith(
                                fontSize: 20, color: amberColor),
                          ),
                        ],
                      ),
                      ...cubit.categories
                          .map(
                            (prod) => TableRow(
                              children: [
                                Text(
                                  prod.id.toString(),
                                  textAlign: TextAlign.center,
                                ),
                                Text(prod.title),
                              ],
                            ),
                          )
                          .toList()
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.white,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  height: 100,
                  width: 150,
                  title: "اضافة صنف",
                  onPressed: () {
                    Navigator.pushNamed(context, addCategoryScreen,
                        arguments: false);
                  },
                ),
                MyButton(
                  height: 100,
                  width: 150,
                  title: "تعديل صنف",
                  onPressed: () {
                    Navigator.pushNamed(context, addCategoryScreen,
                        arguments: true);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

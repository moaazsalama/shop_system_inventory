import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/product/product_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/constants/strings.dart';
import 'package:mafroshat_tech/presention/widgets/drawer.dart';
import 'package:mafroshat_tech/presention/widgets/myapp_bar.dart';

import '../../widgets/mybutton.dart';
import '../../widgets/text_field.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              var cubit = ProductCubit.getCubit(context);
              return SizedBox(
                height: MediaQuery.of(context).size.height * .6,
                child: DefaultTextStyle(
                  style: bodyStyle,
                  child: SingleChildScrollView(
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
                              'اسم المنتج ',
                              style: bodyStyle.copyWith(
                                  fontSize: 20, color: amberColor),
                            ),
                            Text(
                              'سعر الشراء',
                              style: bodyStyle.copyWith(
                                  fontSize: 20, color: amberColor),
                            ),
                            Text(
                              'نوع الصنف',
                              style: bodyStyle.copyWith(
                                  fontSize: 20, color: amberColor),
                            ),
                            Text(
                              'العدد',
                              style: bodyStyle.copyWith(
                                  fontSize: 20, color: amberColor),
                            ),
                            Text(
                              'سعر البيع',
                              style: bodyStyle.copyWith(
                                  fontSize: 20, color: amberColor),
                            )
                          ],
                        ),
                        ...cubit.products
                            .map(
                              (prod) => TableRow(
                                children: [
                                  Text(
                                    prod.code.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(prod.title),
                                  Text(prod.payementPrice.toString()),
                                  Text(prod.category.title),
                                  Text(prod.amount.toString()),
                                  Text(prod.sellPrice().toString())
                                ],
                              ),
                            )
                            .toList()
                      ],
                    ),
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
                  title: "اضافة منتج",
                  onPressed: () {
                    Navigator.pushNamed(context, addProductScreen,
                        arguments: false);
                  },
                ),
                MyButton(
                  height: 100,
                  width: 150,
                  title: "تعديل منتج",
                  onPressed: () {
                    Navigator.pushNamed(context, addProductScreen,
                        arguments: true);
                    //  ProductCubit.getCubit(context).emit(EditProductState());
                  },
                ),
                MyButton(
                  color: Colors.red,
                  height: 100,
                  width: 150,
                  title: "حذف منتج",
                  onPressed: () async {
                    TextEditingController textEditingController =
                        TextEditingController();
                    var result = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('حذف المنتج'),
                              content: MyTextField(
                                  controller: textEditingController,
                                  hintText: 'ادخل الكود',
                                  labelText: 'الكود'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('الغاء'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('تاكيد الحذف'),
                                ),
                              ],
                            ));
                    if (result == "OK") {
                      if (int.tryParse(textEditingController.text) != null) {
                        ProductCubit.getCubit(context).deleteProduct(
                            int.parse(textEditingController.text), context);
                      }
                    }
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

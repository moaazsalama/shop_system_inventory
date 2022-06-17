import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/category/category_cubit.dart';
import 'package:mafroshat_tech/business_logic/order/order_cubit.dart';
import 'package:mafroshat_tech/business_logic/product/product_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/data/models/category.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';
import 'package:mafroshat_tech/presention/widgets/myapp_bar.dart';
import 'package:mafroshat_tech/presention/widgets/mybutton.dart';

import '../../widgets/text_field.dart';

class EditOrderItemScreen extends StatelessWidget {
  final OrderItem edit;

  const EditOrderItemScreen({Key? key, required this.edit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cubit = OrderCubit.getCubit(context);
    cubit.amountController =
        TextEditingController(text: edit.quantity.toString());
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        //   var cubit = ProductCubit.getCubit(context);
        var category = BlocProvider.of<CategoryCubit>(context);
        cubit.productCubit = ProductCubit.getCubit(context);
        return Scaffold(
          appBar: const MyAppBar(title: 'تعديل منتج'),
          body: Form(
            key: cubit.formKey,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                color: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'معلومات المنتج',
                      textAlign: TextAlign.center,
                      style: titleStyle.copyWith(color: amberColor),
                    ),
                    MyTextField(
                      enabled: false,
                      labelText: 'الكود',
                      hintText: 'برجاء ادخال كود المنتج',
                      controller: TextEditingController(
                          text: edit.product.code.toString()),
                    ),
                    MyTextField(
                      enabled: false,
                      //   validator: cubit.titleValidator,
                      controller:
                          TextEditingController(text: edit.product.title),
                      labelText: 'اسم',
                      hintText: 'برجاء ادخال اسم المنتج',
                    ),
                    MyTextField(
                      enabled: false,
                      controller: TextEditingController(
                          text: edit.product.sellPrices.toString()),
                      labelText: 'سعر البيع',
                      hintText: 'برجاء ادخال سعر بيع المنتج',
                    ),
                    MyTextField(
                      validator: ProductCubit.getCubit(context).amountValidator,
                      controller: cubit.amountController,
                      labelText: 'العدد',
                      hintText: 'برجاء ادخال عدد المنتج',
                    ),
                    MyButton(
                      fontSize: 20,
                      title: 'تاكيد',
                      onPressed: () async {
                        await OrderCubit.getCubit(context)
                            .updateOrderItem(edit);
                        Navigator.pop(context);
                      },
                      width: 100,
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

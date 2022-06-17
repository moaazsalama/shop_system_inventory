import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/category/category_cubit.dart';
import 'package:mafroshat_tech/business_logic/product/product_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/data/models/category.dart';
import 'package:mafroshat_tech/presention/widgets/myapp_bar.dart';
import 'package:mafroshat_tech/presention/widgets/mybutton.dart';

import '../../widgets/text_field.dart';

class AddProductScreen extends StatelessWidget {
  final bool edit;

  const AddProductScreen({Key? key, required this.edit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var cubit = ProductCubit.getCubit(context);
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        var cubit = ProductCubit.getCubit(context);
        var category = BlocProvider.of<CategoryCubit>(context);
        return Scaffold(
          appBar: const MyAppBar(title: 'اضافة منتج'),
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
                      suffix: edit
                          ? IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                cubit.autofill(context);
                              })
                          : null,
                      validator: (String? code) =>
                          cubit.codeValidator(code, edit),
                      controller: cubit.codeController,
                      labelText: 'الكود',
                      hintText: 'برجاء ادخال كود المنتج',
                    ),
                    MyTextField(
                      validator: cubit.titleValidator,
                      controller: cubit.titleController,
                      labelText: 'اسم',
                      hintText: 'برجاء ادخال اسم المنتج',
                    ),
                    MyTextField(
                      validator: cubit.priceValidator,
                      controller: cubit.paymentPriceController,
                      labelText: 'سعر الشراء',
                      hintText: 'برجاء ادخال سعر شراء المنتج',
                    ),
                    MyTextField(
                      validator: cubit.priceValidator,
                      controller: cubit.sellPriceController,
                      labelText: 'سعر البيع',
                      hintText: 'برجاء ادخال سعر بيع المنتج',
                    ),
                    MyTextField(
                      validator: cubit.amountValidator,
                      controller: cubit.amountController,
                      labelText: 'العدد',
                      hintText: 'برجاء ادخال عدد المنتج',
                    ),
                    BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) {
                        if (category.categories.isEmpty) {
                          return Container();
                        }
                        return DropdownButton<Category>(
                          itemHeight: 50,
                          isExpanded: true,
                          value: cubit.selectedCategory ??
                              category.categories.first,
                          items: category.categories
                              .map((e) => DropdownMenuItem<Category>(
                                    child: Text(e.title),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: cubit.onChanged,
                        );
                      },
                    ),
                    MyButton(
                      fontSize: 20,
                      title: 'تاكيد',
                      onPressed: edit
                          ? cubit.searched
                              ? () {
                                  cubit.save(context);
                                }
                              : null
                          : () {
                              cubit.submit(context);
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

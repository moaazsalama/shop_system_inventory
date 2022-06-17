import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/category/category_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/presention/widgets/myapp_bar.dart';
import 'package:mafroshat_tech/presention/widgets/mybutton.dart';

import '../../widgets/text_field.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({Key? key, required this.edit}) : super(key: key);
  final bool edit;
  @override
  Widget build(BuildContext context) {
    var cubit = CategoryCubit.getCubit(context);
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
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
                      'معلومات الصنف',
                      textAlign: TextAlign.center,
                      style: titleStyle.copyWith(color: amberColor),
                    ),
                    MyTextField(
                      suffix: edit
                          ? IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                cubit.autofill(context);
                              })
                          : null,
                      validator: (value) => cubit.codeValidator(value, edit),
                      controller: cubit.codeController,
                      labelText: 'الكود',
                      hintText: 'برجاء ادخال كود الصنف',
                    ),
                    MyTextField(
                      validator: cubit.titleValidator,
                      controller: cubit.titleController,
                      labelText: 'اسم',
                      hintText: 'برجاء ادخال اسم الصنف',
                    ),
                    MyButton(
                      fontSize: 20,
                      title: 'تاكيد',
                      onPressed: edit
                          ? cubit.search
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

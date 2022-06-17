import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cart/cart_cubit.dart';
import '../../business_logic/home/home_cubit.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/product.dart';
import 'mybutton.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    var home = HomeCubit.getCubit(context);
    var cart = CartCubit.getCubit(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          //alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 2)),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    item("الكود ", product.code.toString()),
                    item("الاسم", product.title),
                    item("العدد", product.amount.toString() + " قطع "),
                    item("السعر ", product.sellPrice().toString() + " جنية"),
                    item("الصنف ", product.category.title),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  //   decoration: BoxDecoration(color: Colors.grey),
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: home.counter,
                        decoration: InputDecoration(
                            // fillColor: Colors.white,
                            filled: true,
                            hintStyle: titleStyle.copyWith(color: Colors.black),
                            labelText: "الكمية",
                            hintText: "ادخل العدد",
                            labelStyle: headLineStyle.copyWith(
                                color: amberColor,
                                fontWeight: FontWeight.bold)),
                        onChanged: (value) {
                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                          home.emit(HomeInitial());
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyButton(
                        title: 'اضافة الي السلة',
                        width: 200,
                        height: 100,
                        onPressed: home.validcount
                            ? () {
                                if (int.parse(home.counter.text) <=
                                    product.amount) {
                                  var cartItem = CartItem(
                                      product: product,
                                      amount: int.parse(home.counter.text));
                                  cart.addItemToCart(cartItem);
                                  home.clear();
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget item(String s, String code) {
    return RichText(
        text: TextSpan(
      children: [
        TextSpan(
            text: s,
            style: headLineStyle2.copyWith(
                color: amberColor, fontWeight: FontWeight.bold)),
        TextSpan(
            text: ":  ",
            style: headLineStyle.copyWith(
                color: Colors.red, fontWeight: FontWeight.bold)),
        TextSpan(
          text: code,
          style: headLineStyle,
        ),
      ],
    ));
  }
}

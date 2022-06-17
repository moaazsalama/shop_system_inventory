import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/cart/cart_cubit.dart';
import 'package:mafroshat_tech/business_logic/home/home_cubit.dart';

import 'package:mafroshat_tech/business_logic/product/product_cubit.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/data/models/cart_item.dart' show CartItem;
import 'package:mafroshat_tech/presention/widgets/mybutton.dart';
import 'package:mafroshat_tech/presention/widgets/text_field.dart';

import '../widgets/cart_item_widget.dart';
import '../widgets/drawer.dart';
import '../widgets/myapp_bar.dart';
import '../widgets/product_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ProductCubit.getCubit(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var home = HomeCubit.getCubit(context);
        return Scaffold(
          drawer: const DrawerWidget(),
          appBar: const MyAppBar(),
          body: Row(children: [
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: home.controller,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: amberColor),
                                    borderRadius: BorderRadius.circular(15)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(15)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: amberColor),
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: amberColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: DropdownButton<String>(
                              hint: Text(
                                "بحث بواسطة",
                                style: headLineStyle,
                              ),
                              style:
                                  headLineStyle.copyWith(color: Colors.white),

                              borderRadius: BorderRadius.circular(15),
                              //    focusColor: Colors.white,
                              // autofocus: true,
                              underline: Container(),
                              dropdownColor: amberColor,
                              items: home.searchTypes
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e,
                                            style: headLineStyle.copyWith(
                                                color: Colors.black)),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: home.switchTypes,
                              value: home.currentSearch,
                            ),
                          ),
                        ),
                        MyButton(
                          title: 'بحث',
                          onPressed: () => home.search(cubit.products),
                        )
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            ProductWidget(product: home.resultPrdoucct[index]),
                        itemCount: home.resultPrdoucct.length,
                      ),
                    )
                  ],
                )),
            BlocConsumer<CartCubit, CartState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                var cart = CartCubit.getCubit(context);
                var discount;
                return Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        border: Border.all(width: 10, color: Colors.black87)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'الفاتورة',
                            style: titleStyle.copyWith(),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'الاسم ',
                                style: titleStyle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'الكمية',
                                    style: titleStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'x',
                                      style: titleStyle.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    'سعر البيع',
                                    style: titleStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'الاجمالي',
                                      style: titleStyle.copyWith(
                                          color: amberColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                            padding: const EdgeInsets.all(3),
                            itemBuilder: (context, index) =>
                                CartItemWidget(cartItem: cart.items[index]),
                            itemCount: cart.items.length,
                          ),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'الاجمالي',
                                style: titleStyle.copyWith(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Text(
                              cart.totalPrice().toString(),
                              style: titleStyle.copyWith(
                                  color: amberColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'الخصم ',
                                style: bodyStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  child: MyTextField(
                                    inputBorder: InputBorder.none,
                                    filled: true,
                                    onChanged: (p0) {
                                      cart.emit(CartInitial());
                                    },
                                    controller: cart.discount,
                                  ),
                                  width: 70,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'جنية ',
                                    style: bodyStyle.copyWith(
                                      color: amberColor,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'بعد الخصم',
                                style: titleStyle.copyWith(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  (cart.afterDiscount()).toString(),
                                  style: titleStyle.copyWith(
                                      color: amberColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'جنية ',
                                    style: bodyStyle.copyWith(
                                      color: amberColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'اسم العميل',
                                style: bodyStyle.copyWith(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: MyTextField(
                                controller: cart.client,
                              ),
                            )
                          ],
                        ),
                        Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' كود البياع',
                                style: bodyStyle.copyWith(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: 70,
                                child: MyTextField(
                                  controller: cart.sellerCode,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyButton(
                              title: 'مسح الجميع',
                              color: Colors.red,
                              onPressed: () {
                                cart.clear();
                                cart.emit(CartInitial());
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: home.isLoading
                                      ? CircularProgressIndicator()
                                      : MyButton(
                                          title: 'اتمام الفاتورة',
                                          onPressed: () async {
                                            home.isLoading = true;
                                            home.emit(HomeInitial());
                                            try {
                                              var order =
                                                  await cart.submit(context);
                                              await cubit.decrementProducts(
                                                  order.orderItems);

                                              home.isLoading = false;
                                              home.emit(HomeInitial());
                                            } on Exception catch (e) {
                                              home.isLoading = false;
                                              home.emit(HomeInitial());
                                            }
                                          },
                                        )),
                            ),
                          ].reversed.toList(),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ]),
        );
      },
    );
  }
}

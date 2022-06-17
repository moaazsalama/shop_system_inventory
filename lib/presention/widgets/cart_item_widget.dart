import 'package:flutter/material.dart';
import 'package:mafroshat_tech/constants/colors.dart';
import 'package:mafroshat_tech/constants/fonts.dart';

import '../../business_logic/cart/cart_cubit.dart';
import '../../data/models/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        CartCubit.getCubit(context).removeItemFromCart(cartItem);
      },
      key: ValueKey<int>(cartItem.product.code),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              cartItem.product.title,
              style: titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  cartItem.amount.toString(),
                  style: titleStyle.copyWith(color: Colors.white, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'x',
                    style:
                        titleStyle.copyWith(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  cartItem.product.sellPrice().toString() + "=",
                  style: titleStyle.copyWith(color: Colors.white, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (cartItem.amount * cartItem.product.sellPrice()).toString(),
                    style: titleStyle.copyWith(
                      color: amberColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      background: Container(
        color: Colors.red,
      ),
      secondaryBackground: Container(
        color: Colors.black,
      ),
    );
  }
}

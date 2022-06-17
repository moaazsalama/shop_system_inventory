import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/business_logic/order/order_cubit.dart';
import 'package:mafroshat_tech/data/models/order.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';

import '../../data/models/cart_item.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  var discount = TextEditingController();

  var client = TextEditingController();

  var sellerCode = TextEditingController();

  CartCubit() : super(CartInitial());
  List<CartItem> items = [];

  static CartCubit getCubit(context) => BlocProvider.of<CartCubit>(context);
  addItemToCart(CartItem item) {
    print(item);
    var indexWhere = items.indexWhere(
      (element) => element.product == item.product,
    );
    if (indexWhere >= 0) {
      items[indexWhere].amount += item.amount;
    } else {
      items.add(item);
    }
  }

  bool removeItemFromCart(CartItem item) {
    var indexWhere = items.indexWhere(
      (element) => element.product == item.product,
    );
    if (indexWhere >= 0) {
      print(5);
      items.removeAt(indexWhere);

      emit(CartInitial());
      return true;
    } else {
      return false;
    }
  }

  double totalPrice() {
    double price = 0;
    for (var element in items) {
      price += element.product.sellPrice() * element.amount;
    }
    return price;
  }

  afterDiscount() {
    try {
      var parse = double.parse(discount.text);
      return totalPrice() - parse;
    } catch (e) {
      return totalPrice();
    }
  }

  Future<Order> submit(BuildContext context) async {
    var order = Order(
        dateTime: DateTime.now(),
        discount: double.parse(discount.text),
        clinentName: client.text,
        sellerId: int.parse(sellerCode.text),
        orderItems: items
            .map((e) => OrderItem(product: e.product, quantity: e.amount))
            .toList());
    await BlocProvider.of<OrderCubit>(context).addOrder(order);
    clear();
    emit(CartInitial());
    return order;
  }

  clear() {
    client.clear();
    discount.clear();
    items.clear();
    sellerCode.clear();
  }
}

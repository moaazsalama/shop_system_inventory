import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mafroshat_tech/business_logic/pdf/pdf_cubit.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';
import 'package:mafroshat_tech/data/repo/repoProducts.dart';
import 'package:mafroshat_tech/data/repo/repo_order.dart';

import '../../data/models/order.dart';
import '../product/product_cubit.dart';
import 'package:mafroshat_tech/data/models/datetime.dart' show Readable;
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  var formKey = GlobalKey<FormState>();
  late ProductCubit productCubit;
  OrderCubit() : super(OrderInitial());
  RepoProducts repoProducts = RepoProducts().getInstance;
  RepoOrder repoOrder = RepoOrder();

  TextEditingController amountController = TextEditingController();
  static OrderCubit getCubit(context) => BlocProvider.of<OrderCubit>(context);
  List<Order> orders = [];
  Future<void> addOrder(Order order) async {
    var i = await repoOrder.addOrder(order);
    var copyWith = order.copyWith(
      order_Id: i,
    );
    print(copyWith);
    orders.add(copyWith);
    PdfCubit.getPdf(order: copyWith);
    emit(OrderInitial());
  }

  double dailySell() {
    var total = 0.0;
    orders.forEach((element) {
      if (element.dateTime.isToday)
        element.orderItems.forEach((element) {
          total += (element.product.sellPrices * element.quantity);
        });
    });
    return total;
  }

  double weekySell() {
    var total = 0.0;

    var dateTime = DateTime.now().day;

    var weekNumber = (dateTime / 4).toInt();
    orders.forEach((element) {
      var elementWeakNumber = (element.dateTime.day / 4).toInt();
      if (element.dateTime.isInThisMonth && weekNumber == elementWeakNumber)
        element.orderItems.forEach((element) {
          total += (element.product.sellPrices * element.quantity);
        });
    });
    return total;
  }

  double monthlySell() {
    var total = 0.0;
    orders.forEach((element) {
      if (element.dateTime.isInThisMonth)
        element.orderItems.forEach((element) {
          total += (element.product.sellPrices * element.quantity);
        });
    });
    return total;
  }

  double yearlySell() {
    var total = 0.0;
    orders.forEach((element) {
      if (element.dateTime.isInThisYear)
        element.orderItems.forEach((element) {
          total += (element.product.sellPrices * element.quantity);
        });
    });
    return total;
  }

  getProducts() async {
    orders = await repoOrder.getOrders();
    emit(OrderInitial());
  }

  removeOrderItem(OrderItem orderITem, context) async {
    await repoOrder.removeOrderItem(orderITem);
    var indexOrder =
        orders.indexWhere((element) => element.orderId == orderITem.orderId);
    var indexWhere = orders[indexOrder].orderItems.indexWhere((element) {
      print(element.orderItemID);
      print(orderITem.orderItemID);
      return element.orderItemID == orderITem.orderItemID;
    });
    orders[indexOrder].orderItems.removeAt(indexWhere);
    var cubit = ProductCubit.getCubit(context);
    var firstWhere = cubit.products
        .indexWhere((element) => orderITem.product.code == element.code);
    cubit.products[indexWhere] = cubit.products[indexWhere].copyWith(
        amount: cubit.products[indexWhere].amount + orderITem.quantity);
    var index =
        orders.indexWhere((element) => element.orderId == orderITem.orderId);
    if (orders[index].orderItems.length == 0) {
      var val = await removeOrder(orders[index], context);
      orders.removeWhere((element) => element.orderId == orderITem.orderId);
    }

    cubit.emit(ProductInitial());
    emit(OrderInitial());
  }

  Future<bool> removeOrder(Order order, context) async {
    for (var i = 0; i < order.orderItems.length; i++) {
      await removeOrderItem(order.orderItems[i], context);
    }

    orders.removeWhere((element) => element.orderId == order.orderId);

    var val = await repoOrder.deleteOrder(order);
    emit(OrderInitial());
    return val;
  }

  Future<void> updateOrderItem(OrderItem orderITem) async {
    var copyWith =
        orderITem.copyWith(quantity: int.parse(amountController.text));
    updateItem(copyWith);
    await repoOrder.updateOrderItem(copyWith);
    var different = orderITem.quantity - copyWith.quantity;
    var copyWith2 =
        copyWith.product.copyWith(amount: copyWith.product.amount + different);

    await productCubit.repoProducts.update(copyWith2);

    var indexWhere = productCubit.products.indexWhere(
      (element) => copyWith2.code == element.code,
    );
    productCubit.products[indexWhere] = copyWith2;
    emit(OrderInitial());
    productCubit.emit(ProductInitial());
  }

  void updateItem(OrderItem copyWith) {
    var orderIndex =
        orders.indexWhere((element) => element.orderId == copyWith.orderId);
    var orderItemIndex = orders[orderIndex]
        .orderItems
        .indexWhere((element) => element.orderItemID == copyWith.orderItemID);
    orders[orderIndex].orderItems[orderItemIndex] = copyWith;
    emit(OrderInitial());
  }
}

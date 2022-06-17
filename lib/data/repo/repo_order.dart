import 'package:mafroshat_tech/data/database/datatbase.dart';
import 'package:mafroshat_tech/data/models/order.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';

class RepoOrder {
  Databasae databasae = Databasae();
  Future<List<Order>> getOrders() async {
    var products = await databasae.getOrders();

    List<Order> list = [];

    products?.forEach((element) {
      list.add(Order.fromMap(element.fields));
    });
    for (var i = 0; i < list.length; i++) {
      var orderItems = await getOrderItems(list[i].orderId!);
      list[i] = list[i].copyWith(orderItems: orderItems);
    }

    return list;
  }

  Future<List<OrderItem>> getOrderItems(int orderId) async {
    var products = await databasae.getOrdersItems(orderId);

    List<OrderItem> list = [];
    products.forEach((element) {
      list.add(OrderItem.fromMap(element.fields));
    });
    return list;
  }

  Future<int> addOrder(Order order) async {
    var insertCategory = await databasae.insertOrder(order);
    var insertId = insertCategory.insertId;
    order = order.copyWith(order_Id: insertId);
    if (insertId != null) {
      await databasae.insertOrderItems(order.orderItems, insertId);
    }
    return insertId!;
  }

  Future<bool> update(Order order) {
    return databasae.updateOrder(order);
  }

  Future<void> removeOrderItem(OrderItem orderITem) async {
    await databasae.deleteOrderItem(orderITem);
    await databasae.updateProduct(orderITem.product
        .copyWith(amount: orderITem.quantity + orderITem.product.amount));
  }

  Future<bool> deleteOrder(Order order) async {
    return await databasae.removeOrder(order);
  }

  Future<bool> updateOrderItem(OrderItem orderITem) async {
    return await databasae.updateOrderItem(orderITem);
  }
}

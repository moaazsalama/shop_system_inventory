import 'package:mafroshat_tech/data/models/category.dart';
import 'package:mafroshat_tech/data/models/order.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';
import 'package:mafroshat_tech/data/models/product.dart';
import 'package:mysql1/mysql1.dart';

class Databasae {
  static late MySqlConnection database;
  static const host = 'localhost';
  static const user = 'root';
  static const db = 'tech';

  static Future<bool> init() async {
    try {
      var settings = ConnectionSettings(host: host, user: user, db: db);

      database = await MySqlConnection.connect(settings);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Results?> getProducts() async {
    try {
      var results = await database.query(
          'SELECT * FROM `product`JOIN category ON product.category_id = category.category_id');

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<Results?> getCategorys() async {
    try {
      var results = await database.query('SELECT * FROM `category`');

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<Results?> insertCategory(Category category) async {
    try {
      var results = await database.query(
          "INSERT INTO `category`(`category_id`, `category_title`) VALUES ('${category.id}','${category.title}')");

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<Results?> insertProduct(Product product) async {
    try {
      var results = await database.query(
          "INSERT INTO `product`(`prod_id`, `amount`, `title`, `payment_price`, `category_id`, `sell_price`) VALUES ('${product.code}','${product.amount}','${product.title}','${product.payementPrice}','${product.category.id}','${product.sellPrices}')");

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      await database.query(
          "UPDATE `product` SET `prod_id`='${product.code}',`amount`='${product.amount}',`title`='${product.title}',`payment_price`='${product.payementPrice}',`category_id`='${product.category.id}', `sell_price`='${product.sellPrices}' WHERE prod_id =${product.code}");
      return true;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await database.query("DELETE FROM `product` WHERE prod_id=$id");
      return true;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<bool> updateCategory(Category category) async {
    try {
      await database.query(
          "UPDATE `category` SET `category_id`='${category.id}',`category_title`='${category.title}' WHERE category_id=${category.id}");
      return true;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<bool> updateOrder(Order order) async {
    return false;
  }

  Future<Results> insertOrder(Order order) async {
    try {
      var results = await database.query(
          "INSERT INTO `orders`(  `dateTime`, `discount`, `client_name`, `seller_id`) VALUES ('${order.dateTime}','${order.discount}','${order.clinentName}','${order.sellerId}')");

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<bool> insertOrderItems(List<OrderItem> orderItems, int orderID) async {
    try {
      for (int i = 0; i < orderItems.length; i++) {
        var item = orderItems[i];
        var results = await database.query(
            "INSERT INTO `order_item`(`quantity`, `prod_id`, `order_id`) VALUES ('${item.quantity}','${item.product.code}','$orderID')");
        orderItems[i] = orderItems[i]
            .copyWith(orderItemID: results.insertId, orderId: orderID);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Results?> getOrders() async {
    try {
      var results = await database.query('SELECT * FROM `orders`');

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<Results> getOrdersItems(int orderId) async {
    try {
      var results = await database.query(
          'SELECT * FROM `order_item`  JOIN product on order_item.prod_id=product.prod_id JOIN category ON category.category_id=product.category_id WHERE order_id =$orderId');

      return results;
    } catch (e) {
      throw "Error in database";
    }
  }

  Future<bool> deleteOrderItem(OrderItem orderITem) async {
    try {
      var results = await database.query(
          "DELETE FROM `order_item` WHERE `orderItem_id`=${orderITem.orderItemID}");
      print(results.affectedRows);
      return true;
    } catch (e) {
      throw "Error in database";
    }
  }

  void removeOrderItem(OrderItem orderItem) {}

  Future<bool> removeOrder(Order order) async {
    try {
      var results = await database
          .query("DELETE FROM `orders` WHERE `order_id`=${order.orderId}");
      print(results.affectedRows);
      return true;
    } catch (e) {
      throw "Error in data";
    }
  }

  Future<bool> updateOrderItem(OrderItem orderitem) async {
    try {
      await database.query(
          "UPDATE `order_item` SET `quantity`='${orderitem.quantity}' WHERE orderItem_id=${orderitem.orderItemID}");
      return true;
    } catch (e) {
      throw "Error in database";
    }
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mafroshat_tech/data/models/order.dart';
import 'package:mafroshat_tech/data/models/product.dart';

import 'category.dart';

class OrderItem {
  final int? orderItemID;
  final Product product;
  final int? orderId;
  final int quantity;
  OrderItem({
    this.orderItemID,
    required this.product,
    this.orderId,
    required this.quantity,
  });

  OrderItem copyWith({
    int? orderItemID,
    Product? product,
    int? orderId,
    int? quantity,
  }) {
    return OrderItem(
      orderItemID: orderItemID ?? this.orderItemID,
      product: product ?? this.product,
      orderId: orderId ?? this.orderId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderItemID': orderItemID,
      'product': product.toMap(),
      'orderId': orderId,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    print(map);
    return OrderItem(
      orderItemID:
          map['orderItem_id'] != null ? map['orderItem_id'] as int : null,
      product: Product(
        code: map['prod_id'] as int,
        title: map['title'] as String,
        payementPrice: map['payment_price'] as double,
        sellPrices: map['sell_price'] as double,
        amount: map['amount'] as int,
        category: Category.fromMap({
          'category_id': map['category_id'],
          'category_title': map['category_title'],
        }),
      ),
      orderId: int.parse(map['order_id'].toString()),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderITem(orderItemID: $orderItemID, product: $product, orderId: $orderId, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.orderItemID == orderItemID &&
        other.product == product &&
        other.orderId == orderId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return orderItemID.hashCode ^
        product.hashCode ^
        orderId.hashCode ^
        quantity.hashCode;
  }
}

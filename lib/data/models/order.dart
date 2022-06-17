// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mafroshat_tech/data/models/order_item.dart';

import 'cart_item.dart';

class Order {
  final int? orderId;

  final DateTime dateTime;
  final double discount;
  final String clinentName;
  final int sellerId;
  final List<OrderItem> orderItems;
  Order({
    this.orderId,
    required this.dateTime,
    required this.discount,
    required this.clinentName,
    required this.sellerId,
    required this.orderItems,
  });

  Order copyWith({
    int? order_Id,
    DateTime? dateTime,
    double? discount,
    String? clinentName,
    int? sellerId,
    List<OrderItem>? orderItems,
  }) {
    return Order(
      orderId: order_Id ?? this.orderId,
      dateTime: dateTime ?? this.dateTime,
      discount: discount ?? this.discount,
      clinentName: clinentName ?? this.clinentName,
      sellerId: sellerId ?? this.sellerId,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order_Id': orderId,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'discount': discount,
      'clinentName': clinentName,
      'sellerId': sellerId,
      'orderItems': orderItems.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['order_id'] != null
          ? int.parse(map['order_id'].toString())
          : null,
      dateTime: DateTime.parse(map['dateTime'].toString()),
      discount: map['discount'] as double,
      clinentName: map['client_name'] as String,
      sellerId: map['seller_id'] as int,
      orderItems: map['orderItems'] == null
          ? []
          : List<OrderItem>.from(
              (map['orderItems'] as List<int>).map<OrderItem>(
                (x) => OrderItem.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(order_Id: $orderId, dateTime: $dateTime, discount: $discount, clinentName: $clinentName, sellerId: $sellerId, orderItems: $orderItems)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Order &&
        other.orderId == orderId &&
        other.dateTime == dateTime &&
        other.discount == discount &&
        other.clinentName == clinentName &&
        other.sellerId == sellerId &&
        listEquals(other.orderItems, orderItems);
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        dateTime.hashCode ^
        discount.hashCode ^
        clinentName.hashCode ^
        sellerId.hashCode ^
        orderItems.hashCode;
  }

  double getTotoal() {
    var total = 0.0;
    orderItems.forEach((element) {
      total += element.quantity * element.product.sellPrices;
    });
    return total;
  }
}

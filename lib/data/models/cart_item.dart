// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mafroshat_tech/data/models/product.dart';

class CartItem {
  Product product;
  int amount;
  CartItem({
    required this.product,
    required this.amount,
  });

  CartItem copyWith({
    Product? producct,
    int? amount,
  }) {
    return CartItem(
      product: producct ?? this.product,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'producct': product.toMap(),
      'amount': amount,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['producct'] as Map<String, dynamic>),
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItem.fromJson(String source) =>
      CartItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CartItem(producct: $product, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartItem &&
        other.product == product &&
        other.amount == amount;
  }

  @override
  int get hashCode => product.hashCode ^ amount.hashCode;
}

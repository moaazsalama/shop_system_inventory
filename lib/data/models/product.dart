// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mafroshat_tech/data/models/business_numbers.dart';
import 'package:mafroshat_tech/data/models/category.dart';

class Product {
  final int code;
  final String title;
  final double payementPrice;
  final double sellPrices;
  final int amount;
  final Category category;
  Product({
    required this.code,
    required this.title,
    required this.payementPrice,
    required this.sellPrices,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'prod_id': code,
      'title': title,
      'payment_price': payementPrice,
      'sell_price': sellPrices,
      'amount': amount,
      'category_id': category.id,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      code: map['prod_id'] as int,
      title: map['title'] as String,
      payementPrice: map['payment_price'] as double,
      sellPrices: map['sell_price'] as double,
      amount: map['amount'] as int,
      category: Category.fromMap({
        'category_id': map['category_id'],
        'category_title': map['category_title'],
      }),
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Producct(code: $code, title: $title, payementPrice: $payementPrice, amount: $amount, category: $category)';
  }

  @override
  int get hashCode {
    return code.hashCode ^
        title.hashCode ^
        payementPrice.hashCode ^
        amount.hashCode ^
        category.hashCode;
  }

  double sellPrice() => sellPrices;

  Product copyWith({
    int? code,
    String? title,
    double? payementPrice,
    double? sellPrice,
    int? amount,
    Category? category,
  }) {
    return Product(
      code: code ?? this.code,
      title: title ?? this.title,
      payementPrice: payementPrice ?? this.payementPrice,
      sellPrices: sellPrice ?? this.sellPrices,
      amount: amount ?? this.amount,
      category: category ?? this.category,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_cubit.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoaded extends ProductState {}

class AddProductState extends ProductState {}

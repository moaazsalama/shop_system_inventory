import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/constants/fonts.dart';
import 'package:mafroshat_tech/data/models/cart_item.dart';
import 'package:mafroshat_tech/data/models/category.dart';
import 'package:mafroshat_tech/data/models/order_item.dart';
import 'package:mafroshat_tech/data/models/product.dart';
import 'package:mafroshat_tech/data/repo/repoProducts.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  bool searched = false;
  var formKey = GlobalKey<FormState>();
  var codeController = TextEditingController();
  var titleController = TextEditingController();
  var amountController = TextEditingController();
  var paymentPriceController = TextEditingController();
  var sellPriceController = TextEditingController();
  String? codeValidator(String? code, bool edit) {
    if (code == null || int.tryParse(code) == null || code.isEmpty) {
      return "كود غير صحيح";
    }
    if (edit == false &&
        products.any((element) => element.code.toString() == code)) {
      return "الكود موجود مسبقا";
    }
    return null;
  }

  String? titleValidator(String? title) {
    if (title == null || title.isEmpty) {
      return "برجاء ادخال اسم المنتج";
    }
    return null;
  }

  String? priceValidator(String? price) {
    if (price == null || double.tryParse(price) == null) {
      return "سعر غير صحيح";
    }
    return null;
  }

  String? amountValidator(String? amont) {
    if (amont == null || int.tryParse(amont) == null) {
      return "عدد غير صحيح";
    }
    return null;
  }

  Category? selectedCategory;
  ProductCubit() : super(ProductInitial());
  final RepoProducts repoProducts = RepoProducts().getInstance;
  List<Product> products = [];
  getProducts() async {
    products = await repoProducts.getProducts();

    emit(ProductLoaded());
  }

  autofill(context) {
    var index = products.indexWhere(
      (element) => element.code.toString() == codeController.text,
    );
    if (index == -1) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('الكود غير صحيح'),
              ));
      return;
    }
    var firstWhere = products[index];

    titleController = TextEditingController(text: firstWhere.title);
    amountController =
        TextEditingController(text: firstWhere.amount.toString());
    paymentPriceController =
        TextEditingController(text: firstWhere.payementPrice.toString());
    sellPriceController =
        TextEditingController(text: firstWhere.sellPrices.toString());
    selectedCategory = firstWhere.category;
    searched = true;
    emit(ProductInitial());
  }

  void onChanged(Category? category) {
    selectedCategory = category;
    emit(ProductInitial());
  }

  addProduct() {}
  static ProductCubit getCubit(context) =>
      BlocProvider.of<ProductCubit>(context);
  claer() {
    codeController.clear();
    titleController.clear();
    amountController.clear();
    paymentPriceController.clear();
    sellPriceController.clear();
    selectedCategory = null;
  }

  void submit(BuildContext context) async {
    if (formKey.currentState!.validate() && selectedCategory != null) {
      var product = Product(
          code: int.parse(codeController.text),
          title: titleController.text,
          payementPrice: double.parse(paymentPriceController.text),
          sellPrices: double.parse(sellPriceController.text),
          amount: int.parse(amountController.text),
          category: selectedCategory!);
      await repoProducts.addPrdouct(product);
      products.add(product);
      emit(AddProductState());
      Navigator.pop(context);
      claer();
    } else {
      if (selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('برجاء اختيار الصنف',
              style: headLineStyle.copyWith(color: Colors.red)),
          backgroundColor: Theme.of(context).primaryColor,
        ));
      }
    }
  }

  void save(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    var product = Product(
        code: int.parse(codeController.text),
        title: titleController.text,
        payementPrice: double.parse(paymentPriceController.text),
        sellPrices: double.parse(sellPriceController.text),
        amount: int.parse(amountController.text),
        category: selectedCategory!);
    var update = await repoProducts.update(product);
    var indexWhere = products.indexWhere(
        (element) => element.code.toString() == product.code.toString());
    print(indexWhere);
    var val = await repoProducts.update(product);
    if (val == false) {
      return;
    }

    products[indexWhere] = product;
    emit(AddProductState());
    claer();
    Navigator.pop(context);
  }

  void deleteProduct(int id, BuildContext context) async {
    var any = products.any((element) => element.code == id);
    if (any) {
      var result = await repoProducts.deleteProduct(id);

      products.removeWhere((element) => element.code == id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).accentColor,
          duration: const Duration(seconds: 1),
          content: Text(
            "المنتج حذف بنجاح ",
            style: titleStyle,
          )));
      emit(ProductInitial());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).accentColor,
          duration: const Duration(seconds: 1),
          content: Text("الكود غير موجود ", style: titleStyle)));
    }
  }

  Future<void> decrementProducts(List<OrderItem> items) async {
    for (var item in items) {
      var copyWith =
          item.product.copyWith(amount: item.product.amount - item.quantity);
      var val = await repoProducts.update(copyWith);
      var indexWhere =
          products.indexWhere((element) => element.code == copyWith.code);
      products[indexWhere] = copyWith;
    }
    emit(ProductInitial());
  }
}

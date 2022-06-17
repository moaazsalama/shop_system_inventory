import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/data/models/category.dart';
import 'package:mafroshat_tech/data/repo/repo_category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  var formKey = GlobalKey<FormState>();
  final RepoCategory repoCategory = RepoCategory();
  CategoryCubit() : super(CategoryInitial());
  List<Category> categories = [];
  bool search = false;
  var codeController = TextEditingController();
  var titleController = TextEditingController();
  String? codeValidator(String? code, bool edit) {
    if (code == null || int.tryParse(code) == null || code.isEmpty) {
      return "كود غير صحيح";
    }
    if (edit == false &&
        categories.any((element) => element.id.toString() == code)) {
      return "الكود موجود مسبقا";
    }
    return null;
  }

  String? titleValidator(String? title) {
    if (title == null || title.isEmpty) {
      return "برجاء ادخال اسم الصنف";
    }
    return null;
  }

  void submit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      var category = Category(
          id: int.parse(codeController.text), title: titleController.text);
      addProduct(category);
      categories.add(Category(
          id: int.parse(codeController.text), title: titleController.text));
      clear();
      emit(CategoryLoaded());
    }
  }

  void addProduct(Category category) async {
    repoCategory.addCategory(category);
  }

  clear() {
    titleController.clear();
    codeController.clear();
  }

  static CategoryCubit getCubit(context) =>
      BlocProvider.of<CategoryCubit>(context);
  getCategories() async {
    categories = await repoCategory.getCategories();

    emit(CategoryLoaded());
  }

  void autofill(BuildContext context) {
    var index = categories.indexWhere(
      (element) => element.id.toString() == codeController.text,
    );
    var firstWhere = categories[index];
    titleController = TextEditingController(text: firstWhere.title);
    if (index == -1) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text('الكود غير صحيح'),
              ));
      return;
    }

    search = true;
    emit(CategoryInitial());
  }

  save(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    var category = Category(
        id: int.parse(codeController.text), title: titleController.text);
    var update = await repoCategory.update(category);
    var indexWhere = categories.indexWhere(
        (element) => element.id.toString() == category.id.toString());
    categories[indexWhere] = category;
    emit(CategoryInitial());

    Navigator.pop(context);
  }
}

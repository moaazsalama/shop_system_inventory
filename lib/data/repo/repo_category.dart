import 'package:mafroshat_tech/data/database/datatbase.dart';
import 'package:mafroshat_tech/data/models/category.dart';

class RepoCategory {
  Databasae databasae = Databasae();
  getCategories() async {
    var products = await databasae.getCategorys();
    ;
    List<Category> list = [];
    products?.forEach((element) {
      list.add(Category.fromMap(element.fields));
    });
    return list;
  }

  addCategory(Category category) async {
    var insertCategory = await databasae.insertCategory(category);
  }

  Future<bool> update(Category category) {
    return databasae.updateCategory(category);
  }
}

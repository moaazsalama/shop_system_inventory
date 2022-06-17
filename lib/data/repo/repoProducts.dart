import 'package:mafroshat_tech/data/database/datatbase.dart';
import 'package:mafroshat_tech/data/models/product.dart';
import 'package:mysql1/src/single_connection.dart';

class RepoProducts {
  RepoProducts? repoProducts;

  RepoProducts get getInstance => repoProducts ?? RepoProducts();
  Databasae databasae = Databasae();
  getProducts() async {
    var products = await databasae.getProducts();

    List<Product> list = [];
    products?.forEach((element) {
      list.add(Product.fromMap(element.fields));
    });
    return list;
  }

  addPrdouct(Product product) {
    databasae.insertProduct(product);
  }

  Future<bool> update(Product product) {
    return databasae.updateProduct(product);
  }

  Future<bool> deleteProduct(int id) {
    return databasae.deleteProduct(id);
  }
}

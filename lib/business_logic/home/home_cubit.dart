import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafroshat_tech/data/models/product.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  bool isLoading = false;
  var counter = TextEditingController();
  TextEditingController controller = TextEditingController();

  HomeCubit() : super(HomeInitial());
  var searchTypes = ["الكود", "الاسم"];
  var currentSearch = "الكود";
  List<Product> resultPrdoucct = [];
  bool get validcount => int.tryParse(counter.text) != null;
  static HomeCubit getCubit(context) => BlocProvider.of<HomeCubit>(context);
  search(List<Product> list) {
    if (controller.text.isNotEmpty) if (currentSearch == searchTypes.first) {
      resultPrdoucct = list
          .where((element) => element.code == int.parse(controller.text))
          .toList();
    } else {
      resultPrdoucct =
          list.where((element) => element.title == controller.text).toList();
    }
    emit(HomeInitial());
  }

  void switchTypes(String? value) {
    currentSearch = value!;
    emit(HomeInitial());
  }

  void clear() {
    resultPrdoucct = [];
    controller.clear();
    counter.clear();
    emit(HomeInitial());
  }
}

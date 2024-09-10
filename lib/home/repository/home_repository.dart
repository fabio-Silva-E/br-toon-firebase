import 'package:brtoon/home/result/home_result.dart';
import 'package:brtoon/models/category_model.dart';
import 'package:brtoon/models/item_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    try {
      CollectionReference categoriesRef = _firestore.collection('categories');
      QuerySnapshot querySnapshot = await categoriesRef.get();
      List<CategoryModel> categories = querySnapshot.docs.map((doc) {
        return CategoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return HomeResult<CategoryModel>.success(categories);
    } catch (e) {
      return HomeResult<CategoryModel>.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }

  Future<HomeResult<HistoryModel>> getAllHistory(
      Map<String, dynamic> body) async {
    try {
      CollectionReference productsRef = _firestore.collection('histories');
      Query query = productsRef;
      body.forEach((key, value) {
        query = query.where(key, isEqualTo: value);
      });
      QuerySnapshot querySnapshot = await query.get();
      List<HistoryModel> products = querySnapshot.docs.map((doc) {
        return HistoryModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return HomeResult<HistoryModel>.success(products);
    } catch (e) {
      return HomeResult<HistoryModel>.error(
          'Ocorreu um erro inesperado ao recuperar as histórias');
    }
  }
}

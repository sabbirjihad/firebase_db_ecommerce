import 'package:firebase_bitm12/db/FirestoreHelper.dart';
import 'package:firebase_bitm12/models/product_model.dart';
import 'package:flutter/foundation.dart';

class ProductProvider with ChangeNotifier {
  List<String> categories = [];
  List<ProductModel> productList = [];

  void getCategories() {
    FirestoreHelper.getCategories().listen((snapshot) {
      categories = List.generate(snapshot.docs.length, (index) => snapshot.docs[index].data()['name']);
      print(categories.length);
    });
  }

  void getProducts() {
    FirestoreHelper.getAllProductsForAdmin().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
    });
  }

  void getProductsForUser() {
    FirestoreHelper.getAllProductsForUser().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addProduct(ProductModel productModel) => FirestoreHelper.insertNewProduct(productModel);

}
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? name;
  String? category;
  num? price;
  String? imageStorageRef;
  String? localImagePath;
  String? imageDownloadUrl;
  String? description;
  int? stock;
  bool? isAvailable;
  Timestamp? purchaseDate;

  ProductModel(
      {this.id,
        this.name,
        this.category,
        this.price,
        this.localImagePath,
        this.imageDownloadUrl,
        this.description,
        this.imageStorageRef,
        this.stock = 1,
        this.isAvailable = true,
        this.purchaseDate});

  Map<String, dynamic> toMap() {
    var map = <String,dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageStorageRef': imageStorageRef,
      'localImagePath': localImagePath,
      'imageDownloadUrl': imageDownloadUrl,
      'description': description,
      'stock': stock,
      'isAvailable' : isAvailable,
      'timestamp': purchaseDate,
    };
    return map;
  }

  factory ProductModel.fromMap(Map<String,dynamic> map) => ProductModel(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    price: map['price'],
    imageStorageRef: map['imageStorageRef'],
    localImagePath: map['localImagePath'],
    imageDownloadUrl: map['imageDownloadUrl'],
    description: map['description'],
    stock: map['stock'],
    isAvailable: map['isAvailable'],
    purchaseDate: map['timestamp'],
  );

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, category: $category, price: $price, imageStorageRef: $imageStorageRef, localImagePath: $localImagePath, imageDownloadUrl: $imageDownloadUrl, description: $description, stock: $stock, isAvailable: $isAvailable, purchaseDate: $purchaseDate}';
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bitm12/models/cart_model.dart';
import 'package:firebase_bitm12/models/customer_model.dart';
import 'package:firebase_bitm12/models/order_model.dart';
import 'package:firebase_bitm12/models/product_model.dart';

const collection_category = 'Categories';
const collection_product = 'Products';
const collection_order = 'Orders';
const collection_order_details = 'OrdersDetails';
const collection_customer = 'Customers';
const String _docConstants = 'Constants';
const String collection_Constants = 'orderConstants';
const collectionAdmins = 'Admins';
const _collectionOrderConstants = 'OrderConstants';


class FirestoreHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() => _db.collection(collection_category).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsForAdmin() => _db.collection(collection_product).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsForUser() =>
      _db.collection(collection_product)
          .where('isAvailable', isEqualTo: true)
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByUsersId(String uid) =>
      _db.collection(collection_order)
          .where(USER_ID, isEqualTo: uid)
          .snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() =>
      _db.collection(collection_order)
          .snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>>  getOrderConstants()=> _db.collection(collection_Constants).doc(_docConstants).snapshots();

 static Future<QuerySnapshot<Map<String, dynamic>>> findCustomerByPhone(String phone){
   return _db.collection(collection_customer)
       .where('customerPhone',isEqualTo: phone)
       .get();
 }

  //static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() => _db.collection(_collectionOrderConstants).doc(_docConstants).snapshots();

  static Future<void> insertNewProduct(ProductModel productModel) {
    final docRef = _db.collection(collection_product).doc();
    productModel.id = docRef.id;
    return docRef.set(productModel.toMap());
  }

  static Future<String> insertNewCustomer(CustomerModel customerModel) async {
    final docRef = _db.collection(collection_customer).doc();
    customerModel.customerId = docRef.id;
    await docRef.set(customerModel.toMap());
    return docRef.id;
  }

  static Future<void> updateCustomer(CustomerModel customerModel) {
    final docRef = _db.collection(collection_customer).doc(customerModel.customerId);
    return docRef.update(customerModel.toMap());
  }

  static Future<int> checkForAdminValidity(String uid) async {
    final snapshot = await _db.collection(collectionAdmins).where('uid', isEqualTo: uid).get();
    return snapshot.docs.length;
  }

  // static Future<CustomerModel?> findCustomerByPhone(String phone) async {
  //   final snapshot = await _db.collection(collection_customer).where('customerPhone', isEqualTo: phone).get();
  //   if(snapshot.docs.length > 0) {
  //     return CustomerModel.fromMap(snapshot.docs.first.data());
  //   }
  //   return null;
  // }



  static Future<void> addNewOrder(OrderModel orderModel, List<CartModel> cartModels) async {
   final batch = _db.batch();
    final orderDoc = _db.collection(collection_order).doc();
    orderModel.orderId = orderDoc.id;
    batch.set(orderDoc, orderModel.toMap());
    cartModels.forEach((cartModel) {
      final cartModelDoc = orderDoc.collection(collection_order_details).doc();
      batch.set(cartModelDoc, cartModel.toMap());
    });

    return batch.commit();

  }
}
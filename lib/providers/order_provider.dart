
import 'package:firebase_bitm12/db/FirestoreHelper.dart';
import 'package:firebase_bitm12/models/cart_model.dart';
import 'package:firebase_bitm12/models/order_constants_model.dart';
import 'package:firebase_bitm12/models/order_model.dart';
import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
 OrderConstantsModel orderConstantsModel = OrderConstantsModel();
 List<OrderModel> orders=[];

  Future<void> getOrderConstants() async {
    FirestoreHelper.getOrderConstants().listen((docSnapshot) {
      if(docSnapshot.exists)
      {
        orderConstantsModel = OrderConstantsModel.fromMap(docSnapshot.data()!);
        notifyListeners();
      }
    });

  }
  void getMyOrders(String uid){
    FirestoreHelper.getOrdersByUsersId(uid).listen((event) {

    });
  }

  num getPriceAfterDiscount(num total) {
    return (total - ((total * orderConstantsModel.discount!) / 100)).round();
  }

  num getTotalVatAmount(num total) {
    var t = getPriceAfterDiscount(total);
    return ((t * orderConstantsModel.vat!) / 100).round();
  }

  num getGrandTotal(num total) {
    return getPriceAfterDiscount(total) + getTotalVatAmount(total) + orderConstantsModel.deliveryCharge!;
  }

  Future<void> addNewOrder(OrderModel orderModel, List<CartModel> cartModels) async{
    return FirestoreHelper.addNewOrder(orderModel, cartModels);
  }
}
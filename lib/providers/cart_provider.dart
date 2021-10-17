
import 'package:firebase_bitm12/models/cart_model.dart';
import 'package:firebase_bitm12/models/product_model.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartList = [];

  void addToCart(ProductModel productModel) {
    if(isInCart(productModel.id!)) {
      removeFromCart(productModel.id!);
    }else {
      cartList.add(CartModel(productId: productModel.id!, productName: productModel.name!, price: productModel.price!));
      notifyListeners();
    }
  }

  void removeFromCart(String id) {
    final cartModel = cartList.firstWhere((cartModel) => cartModel.productId == id);
    cartList.remove(cartModel);
    notifyListeners();
  }

  void increaseQty(CartModel cartModel) {
    var index = cartList.indexOf(cartModel);
    cartList[index].qty += 1;
    notifyListeners();
  }

  void decreaseQty(CartModel cartModel) {
    var index = cartList.indexOf(cartModel);
    if(cartList[index].qty > 1) {
      cartList[index].qty -= 1;
    }
    notifyListeners();
  }

  void clearCart() {
    cartList.clear();
    notifyListeners();
  }

  bool isInCart(String id) {
    bool tag = false;
    for(var c in cartList) {
      if(c.productId == id) {
        tag = true;
        break;
      }
    }
    return tag;
  }

  int get totalItemsInCart => cartList.length;

  num getPriceWithQty(CartModel cartModel) => cartModel.price * cartModel.qty;

  num get cartItemsTotalPrice {
    num total = 0;
    cartList.forEach((element) {
      total += element.price * element.qty;
    });
    return total;
  }

  num grandTotal(int discount, int vat, int deliveryCharge) {
    var grandTotal = 0;
    return grandTotal;
  }


}
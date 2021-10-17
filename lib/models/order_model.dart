
import 'package:cloud_firestore/cloud_firestore.dart';

final String ORDER_ID = 'orderId';
final String USER_ID = 'user_id';
final String ORDER_CUSTOMER_ID = 'orderCustomerId';
final String ORDER_TIMESTAMP = 'orderTimestamp';
final String ORDER_GRANDTOTAL = 'orderGrandTotal';
final String ORDER_DISCOUNT = 'orderDiscount';
final String ORDER_DELIVERY_CHARGE = 'orderDeliveryCharge';
final String ORDER_VAT = 'vat';
final String ORDER_ORDER_STATUS = 'orderStatus';
final String ORDER_PAYMENT_METHOD = 'orderPaymentMethod';

class OrderModel {
  String? orderId;
  Timestamp? timestamp;
  String? customerId;
  String? userId;
  num? grandTotal;
  int? discount;
  int? deliveryCharge;
  int? vat;
  String? orderStatus;
  String? paymentMethod;

  OrderModel(
      {this.orderId,
        this.timestamp,
        this.customerId,
        this.grandTotal,
        this.discount,
        this.deliveryCharge,
        this.vat,
        this.orderStatus,
        this.userId,
        this.paymentMethod});

  Map<String,dynamic> toMap() {
    var map = <String,dynamic>{
      ORDER_ID : orderId,
      USER_ID: userId,
      ORDER_CUSTOMER_ID : customerId,
      ORDER_TIMESTAMP : timestamp,
      ORDER_GRANDTOTAL : grandTotal,
      ORDER_DISCOUNT : discount,
      ORDER_DELIVERY_CHARGE : deliveryCharge,
      ORDER_VAT : vat,
      ORDER_ORDER_STATUS : orderStatus,
      ORDER_PAYMENT_METHOD : paymentMethod,
    };

    return map;
  }

  OrderModel.fromMap(Map<String,dynamic> map){
    orderId = map[ORDER_ID];
    userId = map[USER_ID];
    customerId = map[ORDER_CUSTOMER_ID];
    timestamp = map[ORDER_TIMESTAMP];
    grandTotal = map[ORDER_GRANDTOTAL];
    discount = map[ORDER_DISCOUNT];
    deliveryCharge = map[ORDER_DELIVERY_CHARGE];
    vat = map[ORDER_VAT];
    orderStatus = map[ORDER_ORDER_STATUS];
    paymentMethod = map[ORDER_PAYMENT_METHOD];
  }

  @override
  String toString() {
    return 'OrderModel{orderId: $orderId, timestamp: $timestamp, customerId: $customerId, userId: $userId, grandTotal: $grandTotal, discount: $discount, deliveryCharge: $deliveryCharge, vat: $vat, orderStatus: $orderStatus, paymentMethod: $paymentMethod}';
  }
}
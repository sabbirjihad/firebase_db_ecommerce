class OrderDetailsModel {
  String productId;
  String productName;
  num price;
  int qty;

  OrderDetailsModel({
    required this.productId,
    required this.productName,
    required this.price,
    this.qty = 1});

  Map<String,dynamic> toMap() {
    var map = <String,dynamic>{
      'productId' : productId,
      'productName' : productName,
      'price' : price,
      'qty' : qty,
    };
    return map;
  }

  factory OrderDetailsModel.fromMap(Map<String,dynamic> map) => OrderDetailsModel(
    productId: map['productId'],
    productName: map['productName'],
    price: map['price'],
    qty: map['qty'],
  );
}
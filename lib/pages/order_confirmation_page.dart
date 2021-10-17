import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bitm12/auth/firebase_auth_service.dart';
import 'package:firebase_bitm12/models/order_model.dart';
import 'package:firebase_bitm12/pages/product_list_page_user.dart';
import 'package:firebase_bitm12/providers/cart_provider.dart';
import 'package:firebase_bitm12/providers/order_provider.dart';
import 'package:firebase_bitm12/utils/constants.dart';
import 'package:firebase_bitm12/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_successful_page.dart';

class OrderConfirmationPage extends StatefulWidget {
  static final String routeName = '/order_confirmation_page';

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  late OrderProvider _orderProvider;
  late CartProvider _cartProvider;
  late String _customerId;
  bool isInit = true;
  bool isLoading = true;
  String _paymentRadioGroupValue = PaymentMethod.cod;

  @override
  void didChangeDependencies() {

    if(isInit) {
      _orderProvider = Provider.of<OrderProvider>(context);
      _cartProvider = Provider.of<CartProvider>(context);
      _customerId = ModalRoute.of(context)!.settings.arguments as String;
      _orderProvider.getOrderConstants().then((_) {
        setState(() {
          isLoading = false;
        });
      });
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Order'),
      ),
      body: isLoading ?
      Center(child: CircularProgressIndicator(),) :
      SingleChildScrollView(
        child: Column(
          children: [
            buildInvoice(),
            ListTile(
              leading: Radio<String>(
                value: PaymentMethod.cod,
                groupValue: _paymentRadioGroupValue,
                onChanged: (value) {
                  setState(() {
                    _paymentRadioGroupValue = value!;
                  });
                },
              ),
              title: Text(PaymentMethod.cod),
            ),
            ListTile(
              leading: Radio<String>(
                value: PaymentMethod.online,
                groupValue: _paymentRadioGroupValue,
                onChanged: (value) {
                  setState(() {
                    _paymentRadioGroupValue = value!;
                  });
                },
              ),
              title: Text(PaymentMethod.online),
            ),
            ElevatedButton(onPressed: () {
              _placeOrder();
            }, child: Text('PLACE ORDER'))
          ],
        ),
      ),
    );
  }

  Widget buildInvoice() {
    return Card(
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _cartProvider.cartList
                  .map((model) => ListTile(
                title: Text(model.productName),
                subtitle: Text('${model.price} x ${model.qty}'),
                trailing: Text(
                    '$takaSymbol${_cartProvider.getPriceWithQty(model)}'),
              ))
                  .toList(),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '$takaSymbol${_cartProvider.cartItemsTotalPrice}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'After Discount (${_orderProvider.orderConstantsModel.discount}%):',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.getPriceAfterDiscount(_cartProvider.cartItemsTotalPrice)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VAT (${_orderProvider.orderConstantsModel.vat}%):',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.getTotalVatAmount(_cartProvider.cartItemsTotalPrice)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Charge:',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.orderConstantsModel.deliveryCharge}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Grand Total:',
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    '$takaSymbol${_orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice)}',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() {
    final orderModel = OrderModel(
      customerId: _customerId,
      timestamp: Timestamp.fromDate(DateTime.now()),
      userId: FirebaseAuthService.currentUser?.uid,
      orderStatus: OrderStatus.pending,
      paymentMethod: _paymentRadioGroupValue,
      deliveryCharge: _orderProvider.orderConstantsModel.deliveryCharge,
      vat: _orderProvider.orderConstantsModel.vat,
      discount: _orderProvider.orderConstantsModel.discount,
      grandTotal: _orderProvider.getGrandTotal(_cartProvider.cartItemsTotalPrice),
    );
    print(orderModel);
    showMessage(context, 'Please wait');
    _orderProvider
        .addNewOrder(orderModel, _cartProvider.cartList)
        .then((_) {
      _cartProvider.clearCart();
      Navigator.pushNamedAndRemoveUntil(
          context,
          OrderSuccessfulPage.routeName, ModalRoute.withName(ProductListPageUser.routeName));
    }).catchError((error) {
      showMessage(context, 'Failed to save');
      throw error;
    });

  }
}

import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatefulWidget {
  static final String routeName = '/order_successful_page';

  @override
  _OrderSuccessfulPageState createState() => _OrderSuccessfulPageState();
}

class _OrderSuccessfulPageState extends State<OrderSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Placed'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/success.png', width: 150, height: 150, fit: BoxFit.cover,),
            Text('Your order has been placed', style: TextStyle(fontSize: 25),),

          ],
        ),
      ),
    );
  }
}

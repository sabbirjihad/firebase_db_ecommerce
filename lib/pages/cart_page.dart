
import 'package:firebase_bitm12/providers/cart_provider.dart';
import 'package:firebase_bitm12/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkout_customer_info_page.dart';
class CartPage extends StatefulWidget {
  static final String routeName = '/cart_page';
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, provider, _) => IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                provider.clearCart();
              },
            ),
          )
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, _) => Column(
          children: [
            Expanded(
              child: provider.totalItemsInCart == 0 ?
              Center(child: Text('Cart is empty'),) :
              ListView.builder(
                itemCount: provider.cartList.length,
                itemBuilder: (context, index) {
                  final cartModel = provider.cartList[index];
                  return ListTile(
                    title: Text(cartModel.productName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Quantity: ${cartModel.qty}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                provider.decreaseQty(cartModel);
                              },
                            ),
                            Text('QTY'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                provider.increaseQty(cartModel);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text('$takaSymbol${provider.getPriceWithQty(cartModel)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  );
                },
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total: $takaSymbol${provider.cartItemsTotalPrice}', style: TextStyle(fontSize: 18, color: Colors.white),),
                  if(provider.totalItemsInCart > 0) TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: Text('Checkout'),
                    onPressed: () {
                      Navigator.pushNamed(context, CheckoutCustomerInfoPage.routeName);
                      /*if(!FirebaseAuthenticationService.isEmailVerified()) {
                        showEmailVerificationWarningDialog(context);
                      }else {
                        Navigator.pushNamed(context, CheckoutCustomerInfoPage.routeName);
                      }*/
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

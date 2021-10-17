import 'package:firebase_bitm12/models/product_model.dart';
import 'package:firebase_bitm12/providers/cart_provider.dart';
import 'package:firebase_bitm12/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItemUser extends StatefulWidget {
  final ProductModel productModel;
  ProductItemUser(this.productModel);

  @override
  _ProductItemUserState createState() => _ProductItemUserState();
}

class _ProductItemUserState extends State<ProductItemUser> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: Colors.lightBlueAccent,
      child: Column(
        children: [
          Expanded(child: Image.network(widget.productModel.imageDownloadUrl!, width: double.maxFinite, fit: BoxFit.cover,)),
          Text(widget.productModel.name!, style: TextStyle(fontSize: 16, color: Colors.white),),
          Text('$takaSymbol${widget.productModel.price!}', style: TextStyle(fontSize: 26, color: Colors.white),),
          Consumer<CartProvider>(
            builder: (context, provider, _) => ElevatedButton.icon(
                onPressed: () {
                  provider.addToCart(widget.productModel);
                },
                icon: Icon(Icons.shopping_cart),
                label: Text(provider.isInCart(widget.productModel.id!) ? 'Remove from Cart' : 'Add to Cart')
            ),
          ),
        ],
      ),
    );
  }
}

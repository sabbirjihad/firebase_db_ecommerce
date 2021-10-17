import 'package:firebase_bitm12/pages/cart_page.dart';
import 'package:firebase_bitm12/providers/cart_provider.dart';
import 'package:firebase_bitm12/providers/product_provider.dart';
import 'package:firebase_bitm12/widgets/product_item_user.dart';
import 'package:firebase_bitm12/widgets/user_nav_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPageUser extends StatefulWidget {
  static final String routeName = '/product_list_user';

  @override
  _ProductListPageUserState createState() => _ProductListPageUserState();
}

class _ProductListPageUserState extends State<ProductListPageUser> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    _productProvider.getProductsForUser();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserNavDrawer(),
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 30,),
                  onPressed: null,
                ),
                Positioned(
                  left: 1,
                  child: Container(
                    padding: const EdgeInsets.all(1.0),
                    alignment: Alignment.center,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple, shape: BoxShape.circle),
                    child: Consumer<CartProvider>(
                      builder: (context, provider, _) => FittedBox(
                          child: Text('${provider.totalItemsInCart}')
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: GridView.count(
        childAspectRatio: 0.5,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: _productProvider.productList.map((product) => ProductItemUser(product)).toList(),
      ),
    );
  }
}

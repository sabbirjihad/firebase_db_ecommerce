import 'package:firebase_bitm12/auth/firebase_auth_service.dart';
import 'package:firebase_bitm12/pages/login_page.dart';
import 'package:firebase_bitm12/pages/new_product_page.dart';
import 'package:firebase_bitm12/pages/product_list_page_admin.dart';
import 'package:firebase_bitm12/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class DashBoard extends StatefulWidget {
  static const String routeName = '/dashboard';
  //const DashBoard({Key? key}) : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late ProductProvider _productProvider;
  @override
  void didChangeDependencies() {
  _productProvider=Provider.of<ProductProvider>(context,listen: false);
   _productProvider.getCategories();
   _productProvider.getProducts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:Text('DashBoard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
              onPressed: (){
              FirebaseAuthService.logout().then((_) =>
                  Navigator.pushReplacementNamed(context, LoginPage.routeName));

              },
          )
        ],
      ),
      body: GridView.count(
          crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          ElevatedButton(
          child: Text('ADD PRODUCT'),
              onPressed: ()=> Navigator.pushNamed(context, NewProductPage.routeName),
          ),
          ElevatedButton(
            child: Text('VIEW PRODUCT'),
            onPressed: ()=> Navigator.pushNamed(context, ProductListPageAdmin.routeName),
          ),
          ElevatedButton(
            child: Text('VIEW ORDERS'),
            onPressed: (){

            }
            ),
          ElevatedButton(
              child: Text('CUSTOMERS'),
              onPressed: (){

              }
          ),
          ElevatedButton(
              child: Text('ADD CATEGORY'),
              onPressed: (){

              }
          ),
        ],
      )
    );
  }
}

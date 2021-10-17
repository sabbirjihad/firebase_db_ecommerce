import 'package:firebase_bitm12/pages/cart_page.dart';
import 'package:firebase_bitm12/pages/dashboard_page.dart';
import 'package:firebase_bitm12/pages/launcher_page.dart';
import 'package:firebase_bitm12/pages/login_page.dart';
import 'package:firebase_bitm12/pages/new_product_page.dart';
import 'package:firebase_bitm12/pages/order_confirmation_page.dart';
import 'package:firebase_bitm12/pages/order_successful_page.dart';
import 'package:firebase_bitm12/pages/product_list_page_admin.dart';
import 'package:firebase_bitm12/pages/product_list_page_user.dart';
import 'package:firebase_bitm12/providers/cart_provider.dart';
import 'package:firebase_bitm12/providers/customer_provider.dart';
import 'package:firebase_bitm12/providers/order_provider.dart';
import 'package:firebase_bitm12/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/checkout_customer_info_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp()
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ProductProvider()),
        ChangeNotifierProvider(create: (context)=>CartProvider()),
        ChangeNotifierProvider(create: (context)=>OrderProvider()),
        ChangeNotifierProvider(create: (context)=>CustomerProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LauncherPage(),
        routes: {
          LauncherPage.routeName :(context) => LauncherPage(),
          LoginPage.routeName:(context) => LoginPage(),
          DashBoard.routeName:(context) => DashBoard(),
          NewProductPage.routeName:(context)=>NewProductPage(),
          ProductListPageAdmin.routeName:(context)=>ProductListPageAdmin(),
          ProductListPageUser.routeName:(context)=>ProductListPageUser(),
          CartPage.routeName:(context)=>CartPage(),
          CheckoutCustomerInfoPage.routeName:(context)=>CheckoutCustomerInfoPage(),
          OrderConfirmationPage.routeName:(context)=>OrderConfirmationPage(),
          OrderSuccessfulPage.routeName:(context)=>OrderSuccessfulPage(),

        },
      ),
    );
  }
}


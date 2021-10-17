import 'package:firebase_bitm12/auth/firebase_auth_service.dart';
import 'package:firebase_bitm12/pages/dashboard_page.dart';
import 'package:firebase_bitm12/pages/login_page.dart';
import 'package:firebase_bitm12/pages/product_list_page_user.dart';
import 'package:flutter/material.dart';
class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher_page';
  @override
  _LauncherPageState createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero,(){
      if(FirebaseAuthService.currentUser == null){
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
      else{
        FirebaseAuthService.isCurrentUserAdmin(FirebaseAuthService.currentUser!.uid).then((value)
        {
          if(value){
            Navigator.pushReplacementNamed(context, DashBoard.routeName);
          }
          else{
            Navigator.pushReplacementNamed(context, ProductListPageUser.routeName);
          }
        }
        );

      }
    },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

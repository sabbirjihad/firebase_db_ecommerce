import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bitm12/auth/firebase_auth_service.dart';
import 'package:firebase_bitm12/pages/product_list_page_user.dart';
import 'package:firebase_bitm12/utils/helpers.dart';
import 'package:flutter/material.dart';

import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = false;
  final _formKey = GlobalKey<FormState>();
  String errMsg = "";
  String? email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.email)
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock)
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 40,),
                Center(
                  child: ElevatedButton(
                    child: Text('LOGIN as User'),
                    onPressed: () {
                      isLogin = true;
                      _loginUser();
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    child: Text('LOGIN as Admin'),
                    onPressed: () {
                      _loginAdmin();
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New User? '),
                    TextButton(
                      child: Text('Register'),
                      onPressed: () {
                        isLogin = false;
                        _loginUser();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Text(errMsg, style: TextStyle(fontSize: 18),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final uid = await FirebaseAuthService.login(email!, password!);
        if(uid != null) {
          Navigator.pushReplacementNamed(context, ProductListPageUser.routeName);
        }
      } on FirebaseAuthException catch(e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }

  void _loginAdmin() async {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final uid = await FirebaseAuthService.login(email!, password!);
        if(uid != null) {
          if(await FirebaseAuthService.isCurrentUserAdmin(uid)) {
            Navigator.pushReplacementNamed(context, DashBoard.routeName);
          }else {
            showMessage(context, 'You are not an Admin');
          }
        }
      } on FirebaseAuthException catch(e) {
        setState(() {
          errMsg = e.message!;
        });
      }
    }
  }
}

import 'package:firebase_bitm12/auth/firebase_auth_service.dart';
import 'package:firebase_bitm12/pages/login_page.dart';
import 'package:flutter/material.dart';

class UserNavDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My Profile'),
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard),
            title: Text('My Orders'),
          ),
          ListTile(
            onTap: () {
              FirebaseAuthService.logout().then((_) => Navigator.pushReplacementNamed(context, LoginPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}


import 'package:firebase_bitm12/db/FirestoreHelper.dart';
import 'package:firebase_bitm12/models/customer_model.dart';
import 'package:flutter/foundation.dart';

class CustomerProvider with ChangeNotifier {

  Future<CustomerModel?> findCustomer(String phone) async {
    final snapshot = await FirestoreHelper.findCustomerByPhone(phone);
    if(snapshot.docs.length>0){
      final customer= CustomerModel.fromMap(snapshot.docs.first.data());
      return customer;
    }
    return null;
  }

  Future<String> addCustomer(CustomerModel customerModel) async{
   final id = await FirestoreHelper.insertNewCustomer(customerModel);
   return id;
  }

  Future<void> updateCustomer(CustomerModel customerModel) async {
    return FirestoreHelper.updateCustomer(customerModel);
  }

}
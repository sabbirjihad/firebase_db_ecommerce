
import 'package:firebase_bitm12/models/customer_model.dart';
import 'package:firebase_bitm12/providers/customer_provider.dart';
import 'package:firebase_bitm12/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_confirmation_page.dart';

class CheckoutCustomerInfoPage extends StatefulWidget {
  static final String routeName = '/checkout_customer_info';

  @override
  _CheckoutCustomerInfoPageState createState() => _CheckoutCustomerInfoPageState();
}

class _CheckoutCustomerInfoPageState extends State<CheckoutCustomerInfoPage> {
  final _searchPhoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  late CustomerProvider _customerProvider;
  CustomerModel? _customerModel = CustomerModel();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    _customerProvider = Provider.of<CustomerProvider>(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    _searchPhoneController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Information'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                primary: Colors.white
            ),
            child: Text('NEXT'),
            onPressed: () {
              _saveCustomerInfoAndProceedToOrderConfirmationPage();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _findCustomerSection(),
            SizedBox(height: 10,),
            _buildFormSection(),
          ],
        ),
      ),
    );
  }

  Widget _findCustomerSection() {
    return Column(
      children: [
        Text(
          'Existing Customer?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: _searchPhoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              hintText: 'Enter Phone Number',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _findExistingCustomer();
                },
              )),
        ),
      ],
    );
  }

  void _findExistingCustomer() async {
    FocusScope.of(context).unfocus();
    if(_searchPhoneController.text.isEmpty) {
      showMessage(context, 'Provide a phone number');
      return;
    }

    _customerModel = await _customerProvider.findCustomer(_searchPhoneController.text);
    if(_customerModel != null) {
      showMessage(context, 'found');
      setState(() {
        _nameController.text = _customerModel!.customerName!;
        _phoneController.text = _customerModel!.customerPhone!;
        _emailController.text = _customerModel!.customerEmail!;
        _addressController.text = _customerModel!.customerAddress!;
      });

    }else {
      showMessage(context, 'not found');
    }
  }

  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Expanded(
          child: ListView(
            children: [
              SizedBox(height: 10,),
              Text(
                'New Customer?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              Divider(color: Colors.black,),
              SizedBox(height: 10,),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Customer Name'
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  _customerModel!.customerName = value!;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Customer Phone'
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  _customerModel!.customerPhone = value!;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Customer Email'
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  _customerModel!.customerEmail = value!;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Customer Street Address'
                ),
                validator: (value) {
                  return null;
                },
                onSaved: (value) {
                  _customerModel!.customerAddress = value!;
                },
              ),
              SizedBox(height: 10,),
            ],
          )
      ),
    );
  }

  void _saveCustomerInfoAndProceedToOrderConfirmationPage() async {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //next button work
      if(_customerModel!.customerId == null) {
        final customerId = await _customerProvider.addCustomer(_customerModel!);
        Navigator.pushNamed(context, OrderConfirmationPage.routeName, arguments: customerId);
      }else{
        await _customerProvider.updateCustomer(_customerModel!);
        Navigator.pushNamed(context, OrderConfirmationPage.routeName, arguments: _customerModel!.customerId);
      }
    }
  }
}

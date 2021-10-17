import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bitm12/models/product_model.dart';
import 'package:firebase_bitm12/providers/product_provider.dart';
import 'package:firebase_bitm12/utils/constants.dart';
import 'package:firebase_bitm12/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProductPage extends StatefulWidget {
  static final String routeName = '/new_product';
  @override
  _NewProductPageState createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  late ProductProvider provider;
  final _formKey = GlobalKey<FormState>();
  String? category;
  DateTime? _dateTime;
  String? imagePath;
  ImageSource imageSource = ImageSource.camera;
  ProductModel productModel = ProductModel();
  bool isUploading = false;

  @override
  void didChangeDependencies() {
    provider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Product'), actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: isUploading ? null : _saveProduct,
        )
      ],),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Product name'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldMsg;
                }
                return null;
              },
              onSaved: (value) {
                productModel.name = value;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Product Price'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldMsg;
                }

                if(num.parse(value) < 0) {
                  return negativePriceErrMsg;
                }
                return null;
              },
              onSaved: (value) {
                productModel.price = num.parse(value!);
              },
            ),
            SizedBox(height: 10,),
            TextFormField(

              decoration: InputDecoration(
                  labelText: 'Product Description (optional)'
              ),
              validator: (value) {
                return null;
              },
              onSaved: (value) {
                productModel.description = value;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Product Quantity'
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return emptyFieldMsg;
                }

                if(num.parse(value) < 1) {
                  return negativeStockErrMsg;
                }
                return null;
              },
              onSaved: (value) {
                productModel.stock = int.parse(value!);
              },
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  hint: Text('Select a Category'),
                  isExpanded: true,
                  value: category,
                  onChanged: (String? value) {
                    setState(() {
                      category = value!;
                    });
                    productModel.category = category;
                  },
                  items: provider.categories.map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  )).toList(),
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: _showCalendar, child: Text('Select Purchase Date')),
                  Text(_dateTime == null ? 'No Date Selected' : getFormattedDate(_dateTime!, 'dd/MM/yyyy')),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Card(
              elevation: 10,
              child: ListTile(
                leading: imagePath == null ?
                Image.asset('images/placeholder.png', width: 100, height: 100, fit: BoxFit.cover,) :
                Image.file(File(imagePath!), width: 100, height: 100, fit: BoxFit.cover,),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        imageSource = ImageSource.camera;
                        getPhoto();
                      },
                      child: Text('Take Photo'),
                    ),
                    TextButton(
                      onPressed: () {
                        imageSource = ImageSource.gallery;
                        getPhoto();
                      },
                      child: Text('From Gallery'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showCalendar() async {

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );

    if(selectedDate != null) {
      setState(() {
        _dateTime = selectedDate;
      });
      productModel.purchaseDate = Timestamp.fromDate(_dateTime!);
    }
  }

  void getPhoto() async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource, imageQuality: 65);
    print(pickedFile?.path);
    if(pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        isUploading = true;
      });
      showMessage(context, 'Uploading..');
      String? imageRef = 'FlutterBatch10/${DateTime.now().toIso8601String()}';

      final photoRef = FirebaseStorage.instance.ref().child(imageRef);
      final uploadTask = photoRef.putFile(File(imagePath!));
      final snapShot = await uploadTask.whenComplete(() {
        showMessage(context, 'Upload completed');
      });
      final downloadUrl = await snapShot.ref.getDownloadURL();
      setState(() {
        isUploading = false;
      });
      productModel.imageDownloadUrl = downloadUrl;
      productModel.localImagePath = imagePath;
      productModel.imageStorageRef = imageRef;
    }
  }

  void _saveProduct() {
    if(category == null) {
      showMessage(context, 'Please select a category');
      return;
    }

    if(_dateTime == null) {
      showMessage(context, 'Please select a purchase date');
      return;
    }

    if(imagePath == null) {
      showMessage(context, 'No photo chosen for product');
      return;
    }


    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(productModel);
      provider.addProduct(productModel)
          .then((_) => Navigator.pop(context))
          .catchError((error) {
        showMessage(context, 'Could not save');
        throw error;
      }) ;
    }
  }
}

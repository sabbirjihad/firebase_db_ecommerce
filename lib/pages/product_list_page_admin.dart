import 'package:firebase_bitm12/providers/product_provider.dart';
import 'package:firebase_bitm12/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPageAdmin extends StatefulWidget {
  static const String routeName = '/productlistpageadmin';

  @override
  _ProductListPageAdminState createState() => _ProductListPageAdminState();
}

class _ProductListPageAdminState extends State<ProductListPageAdmin> {
  late ProductProvider _productProvider;

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Products'),),
      body: ListView.builder(
        itemCount: _productProvider.productList.length,
        itemBuilder: (context, index) {
          final product = _productProvider.productList[index];
          return ListTile(
            leading: Image.network(product.imageDownloadUrl!, width: 100, height: 100, fit: BoxFit.cover,),
            title: Text(product.name!),
            subtitle: Text(product.category!),
            trailing: Text('$takaSymbol${product.price}'),
          );
        },
      ),
    );
  }
}

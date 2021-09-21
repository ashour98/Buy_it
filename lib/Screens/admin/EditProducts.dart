import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Screens/admin/ManageProducts.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/Custome_TextField.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:flutter/material.dart';

class EditProducts extends StatelessWidget {
  static String id='EditProducts';

  String _Name, _Price, _Description, _Category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store=Store();
  @override
  Widget build(BuildContext context) {
      Product product= ModalRoute.of(context).settings.arguments;
      return Scaffold(
      backgroundColor: KmainColor,

      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*.2,
          ),
          Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomeTextField(
                  onClick: (value) {
                    _Name = value;
                  },
                  hint: 'Product Name',
                ),
                SizedBox(
                  height: 10,
                ),
                CustomeTextField(
                    onClick: (value) {
                      _Price = value;
                    },
                    hint: 'Product Price'),
                SizedBox(
                  height: 10,
                ),
                CustomeTextField(
                    onClick: (value) {
                      _Description = value;
                    },
                    hint: 'Product Description'),
                SizedBox(
                  height: 10,
                ),
                CustomeTextField(
                    onClick: (value) {
                      _Category = value;
                    },
                    hint: 'Product Category'),
                SizedBox(
                  height: 10,
                ),
                CustomeTextField(
                    onClick: (value) {
                      _imageLocation = value;
                    },
                    hint: 'Product Location'),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();
                      
                      _store.editProduct(({
                          kProductName: _Name,
                          kProductPrice: _Price,
                          kProductLocation: _imageLocation,
                          kProductDescription:_Description,
                          kProductCategory:_Category,
                      }), product.pId);
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Add Product'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

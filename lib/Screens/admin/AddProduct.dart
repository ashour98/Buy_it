import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/Custome_TextField.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  String _Name, _Price, _Description, _Category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store=Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KmainColor,
      body: Form(
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
                      
                      _store.addProduct(Product(
                        pName: _Name,
                        pPrice: _Price,
                        pDescription: _Description,
                        pLocation: _imageLocation,
                        pCategory: _Category
                      ));


                      
                    }
                  },
                  child: Text('Add Product'),
                )
              ],
            ),
          ),
    );
  }
}

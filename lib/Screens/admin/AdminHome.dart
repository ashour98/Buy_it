import 'package:buy_it/Screens/admin/AddProduct.dart';
import 'package:buy_it/Screens/admin/ManageProducts.dart';
import 'package:buy_it/Screens/admin/OrderScreen.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:flutter/material.dart';


class AdminHome extends StatelessWidget {
  static String id='AdminHome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KmainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, AddProduct.id);

              },
              child: Text('Add Product'),
          ),
          RaisedButton(
              onPressed: (){
                Navigator.pushNamed(context, ManegeProducts.id);

          },
            child: Text('Edit Product'),

          ),
          RaisedButton(onPressed: (){
            Navigator.pushNamed(context, ScreenOrder.id);

          },
            child: Text('View Orders'),
          ),

        ],
      ),
    );
  }
}

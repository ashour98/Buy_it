import 'package:buy_it/Model/Order.dart';
import 'package:buy_it/Screens/admin/AddProduct.dart';
import 'package:buy_it/Screens/admin/AdminHome.dart';
import 'package:buy_it/Screens/admin/EditProducts.dart';
import 'package:buy_it/Screens/admin/ManageProducts.dart';
import 'package:buy_it/Screens/admin/OrdarDetails.dart';
import 'package:buy_it/Screens/admin/OrderScreen.dart';
import 'package:buy_it/Screens/user/CartScreen.dart';
import 'package:buy_it/Screens/user/productInfo.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:buy_it/provider/ModelHud.dart';
import 'package:buy_it/provider/adminMode.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/LoginScreen.dart';
import 'Screens/SignUpScreen.dart';
import 'Screens/user/HomePage.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool isUserLoggedIn=false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context,snapshots){
        if(!snapshots.hasData){
          return MaterialApp(
            home: Scaffold(body: Center(child: Text('Loading...'),),),
          );
        }
        else{
          isUserLoggedIn =snapshots.data.getBool(kKeepUserLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(
                create: (context) => ModelHud(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              )
            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: isUserLoggedIn ? HomePage.id : LoginScreen.id,
                routes: {
              OrderDetails.id:(context)=>OrderDetails(),
              ScreenOrder.id:(context)=>ScreenOrder(),
              CartScreen.id:(context)=>CartScreen(),
              ProductInfo.id: (context) => ProductInfo(),
              EditProducts.id: (context) => EditProducts(),
              LoginScreen.id: (context) => LoginScreen(),
              SignUpScreen.id: (context) => SignUpScreen(),
              HomePage.id: (context) => HomePage(),
              AdminHome.id: (context) => AdminHome(),
              AddProduct.id: (context) => AddProduct(),
              ManegeProducts.id: (context) => ManegeProducts()
            }),
          );
        }
      },
    );
  }
}

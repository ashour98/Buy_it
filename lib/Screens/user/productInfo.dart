import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Screens/user/CartScreen.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductInfo extends StatefulWidget {
  static String id ='ProductInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity=1;
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              fit: BoxFit.fill,
              image: AssetImage(product.pLocation),

            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                      child: Icon(Icons.arrow_back)),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, CartScreen.id);
                    },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: [
                Opacity(
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height*.34,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.pName,style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 20
                          ),),
                          SizedBox(
                            height: 20,
                          ),
                          Text(product.pDescription,style: TextStyle(
                              fontWeight: FontWeight.w600,fontSize: 20
                          ),),
                          SizedBox(
                            height: 20,
                          ),
                          Text('\$${product.pPrice}',style: TextStyle(
                              fontWeight: FontWeight.w600,fontSize: 20
                          ),),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ClipOval(
                              child: Material(
                                color: KmainColor,
                                child: GestureDetector(
                                  onTap: Add,
                                  child: SizedBox(
                                    child: Icon(Icons.add),
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                              ),
                            ),
                            Text(_quantity.toString()
                            ,style: TextStyle(
                                fontSize: 50
                              ),),
                            ClipOval(
                              child: Material(
                                color: KmainColor,
                                child: GestureDetector(
                                  onTap: subtract,
                                  child: SizedBox(
                                    child: Icon(Icons.remove),
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                              ),
                            ),
                          ],)
                        ],
                      ),
                    ),
                  ),
                  opacity: .5,
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height*.09,
                  child: Builder(
                    builder:(context)=> RaisedButton(
                      child: Text('Add to Cart',style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),),
                        onPressed: (){
                        AddToCart(context,product);

                        },

                      color: KmainColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void subtract() {
    if(_quantity>0){
      setState(() {
        _quantity--;
      });
    }
  }

  void Add() {
    setState(() {
      _quantity++;
    });
  }

  void AddToCart(context,product) {
    CartItem cartItem= Provider.of<CartItem>(context,listen: false);
    bool exist=false;
    var ProductsinCart= cartItem.products;
    for(var ProductinCart in ProductsinCart){
      if(ProductinCart == product) {
        exist = true;
      }
    }
    if(exist){
    product.pQuantity+= _quantity;
    }
    else{
      cartItem.addProduct(product);
      product.pQuantity=_quantity;
    }
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Added to Cart'),
    ));
  }
}

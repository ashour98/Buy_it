import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:buy_it/provider/cartItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static String id= 'CartScreen';
  @override
  Widget build(BuildContext context) {
   final List<Product> products= Provider.of<CartItem>(context).products;
    final double screenHeight= MediaQuery.of(context).size.height;
    final double screenWidth= MediaQuery.of(context).size.width;
    final double appBarHeight=AppBar().preferredSize.height;
    final double statusAppBar=MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
      ),
      body: Column(
        children: [
          LayoutBuilder(
            builder:(context,contrains) {
              if(products.isNotEmpty) {
                return Container(
                  height: screenHeight-statusAppBar-appBarHeight-(screenHeight*.09),
                  child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(products[index].toString()),
                          onDismissed: (direction){
                            products.removeAt(index);
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Item Dismissed')));
                          },
                          background: Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                                child: Icon(Icons.delete,color: Colors.white,size: 40,)),
                            color: Colors.red,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: screenHeight * .15,
                              color: ScondaryColor,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: screenHeight * .15 / 2,
                                    backgroundImage: AssetImage(
                                        products[index].pLocation),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(products[index].pName,
                                                style: TextStyle(fontSize: 18,
                                                    fontWeight: FontWeight
                                                        .bold),),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('\$ ${products[index].pPrice}',
                                                style: TextStyle(fontSize: 18,
                                                    fontWeight: FontWeight
                                                        .bold),),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 20),
                                          child: Text(
                                            products[index].pQuantity.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),),

                                        )
                                      ],),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                );
              }
              else{
                return Container(
                  height: screenHeight - (screenHeight*.09) -appBarHeight-statusAppBar ,
                    child: Center(child: Text('Cart is Empty',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)));
              }
            }
          ),
          Builder(
            builder:(context)=> ButtonTheme(
              minWidth: screenWidth,
              height: screenHeight*.09,
              child: RaisedButton(
                color: KmainColor,
                  child: Text('order'.toUpperCase()),
                  onPressed: (){
                  showAlerDialog(products,context);

              }

              ),
            ),
          ),

        ],
      ),
    );
  }

  void showAlerDialog(List<Product> products,context)async {
    var price= getTotalPrice(products);
    var address;
    AlertDialog alertDialog= AlertDialog(
      actions: [
        MaterialButton(
            child: Text('Confirm'),
            onPressed: (){
              try{
                Store _store=Store();
                _store.OrderProduct({
                  kTotalPrice: price,
                  kAddress:address,

                },products);
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Ordered Successfully')));
                Navigator.pop(context);
              }
              catch(ex){
              print(ex);
              }
            })
      ],
      content: TextField(
        onChanged: (value){
          address=value;
        },
        decoration: InputDecoration(hintText: 'Enter your address'),
      ),
      title: Text('Total Price = \$ $price'),);
    await showDialog(context: context,builder: (context){
      return alertDialog;
    });
  }

  getTotalPrice(List<Product> products) {

    var price =0;
    for(var product in products){
      price+= product.pQuantity*int.parse(product.pPrice);
    }
    return price;
  }
}

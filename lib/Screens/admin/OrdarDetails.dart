import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  static String id='OrderDetails';
  Store store=Store();
@override
  Widget build(BuildContext context) {
  String documentID= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: store.loadOrdersDetails(documentID),
          builder: (context,snapshot){
            if(snapshot.hasData){
              List<Product> products=[];
              for(var doc in snapshot.data.documents){
                products.add(Product(
                  pName: doc.data[kProductName],
                  pQuantity: doc.data[kProductQuantity],
                  pCategory: doc.data[kProductCategory]
                ));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder:(context,index)=> Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                            height: MediaQuery.of(context).size.height*.2,
                            color: ScondaryColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('product Name =${products[index].pName}',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                SizedBox(height: 10,),
                                Text('Quantity =${products[index].pQuantity}',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                SizedBox(height: 10,),
                                Text('product Category =${products[index].pCategory}',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                              ],
                            ),
                          ),
                      ),
                    itemCount: products.length,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                      RaisedButton(
                        child: Text('Confirm Order'),
                          color: Colors.green,
                          onPressed: (){}
                      ),
                      RaisedButton(
                        child: Text('Delete Order'),
                          color: Colors.red,
                          onPressed: (){})
                    ],),
                  )
                ],
              );
            }
            else{
              return Center(
                child: Text('Loding ...'),
              );
            }

      }),
    );
  }
}

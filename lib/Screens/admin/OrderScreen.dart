import 'package:buy_it/Model/Order.dart';
import 'package:buy_it/Screens/admin/OrdarDetails.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ScreenOrder extends StatelessWidget {
  static String id='OrderScreen';
  Store _store =Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadOrders(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
           return Center(child: Text('There is No Date'));
          }
          else{
            List<Order> orders=[];
            for(var doc in snapshot.data.documents){
              orders.add(Order(
                documantID: doc.documentID,
                Address: doc.data[kAddress],
                TotalPrice: doc.data[kTotalPrice],

              ));
            }
            return ListView.builder(
              itemBuilder: (context, index)=> Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, OrderDetails.id,arguments: orders[index].documantID);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height*.2,
                    color: ScondaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Price =\$${orders[index].TotalPrice}',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Address is =\$${orders[index].Address}',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                      ],
                    ),
                  ),
                ),
              ),
              itemCount: orders.length,);
          }
        },
      ),
    );

  }
}

import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Screens/admin/EditProducts.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManegeProducts extends StatefulWidget {
  static String id = 'ManegeProducts';

  @override
  _ManegeProductsState createState() => _ManegeProductsState();
}

class _ManegeProductsState extends State<ManegeProducts> {
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KmainColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = [];

            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              products.add(Product(
                pId: doc.documentID,
                  pPrice: data[kProductPrice],
                  pName: data[kProductName],
                  pCategory: data[kProductCategory],
                  pLocation: data[kProductLocation],
                  pDescription: data[kProductDescription]));
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: .9),
                itemBuilder: (context, index) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: GestureDetector(
                        onTapUp: (details){
                          double dx= details.globalPosition.dx;
                          double dy= details.globalPosition.dy;
                          double dx2= MediaQuery.of(context).size.width -dx;
                          double dy2=MediaQuery.of(context).size.width-dy;
                          showMenu(context: context, position: RelativeRect.fromLTRB(dx, dy, dx2, dy2), items: [
                            MyPopupMenuItem(child: Text('Edit'),OnClick: (){

                              Navigator.pushNamed(context, EditProducts.id,arguments: products[index]);

                            },),
                            MyPopupMenuItem(OnClick: (){

                              _store.DeleteProduct(products[index].pId);
                              Navigator.pop(context);


                            },
                                child: Text('Delete'))


                          ]);
                        },
                        child: Stack(
                          children: [
                            Positioned.fill(
                                child: Image(
                              fit: BoxFit.fill,
                              image: AssetImage(products[index].pLocation),
                            )),
                            Positioned(
                              bottom: 0,
                              child: Opacity(
                                opacity: .5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          products[index].pName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('\$ ${products[index].pPrice}')
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                itemCount: products.length);
          } else
            return Center(child: Text('Loading...'));
        },
      ),
    );
  }
}

class MyPopupMenuItem<T> extends PopupMenuItem<T> {
final Widget child;
final Function OnClick;
MyPopupMenuItem({@required this.child,@required this.OnClick}):
super(child:child);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopupMenuItemState();
  }
}

class MyPopupMenuItemState<T,PopupMenuItem> extends PopupMenuItemState<T,MyPopupMenuItem<T>> {

  @override
  void handleTap() {
    widget.OnClick();
  }
}
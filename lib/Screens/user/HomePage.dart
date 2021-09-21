import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Screens/LoginScreen.dart';
import 'package:buy_it/Screens/user/CartScreen.dart';
import 'package:buy_it/Screens/user/productInfo.dart';
import 'package:buy_it/Services/Auth.dart';
import 'package:buy_it/Services/Store.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = Auth();
  FirebaseUser _loggedUser;
  int _tabBar;
  final _store = Store();
  int _bottomBar = 0;
  List<Product> _products=new List<Product>();
  List<Product> _product=new List<Product>();

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: _store.loadProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {

            for (var doc in snapshot.data.documents) {
              var data = doc.data;
              _product.add(Product(
                  pId: doc.documentID,
                  pPrice: data[kProductPrice],
                  pName: data[kProductName],
                  pCategory: data[kProductCategory],
                  pLocation: data[kProductLocation],
                  pDescription: data[kProductDescription]));
            }

                _products=[..._product];
              _product.clear();
              _products.addAll(_product);

          }
          return Stack(
            children: [
              DefaultTabController(
                  length: 4,
                  child: Scaffold(
                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      fixedColor: KmainColor,
                      currentIndex: _bottomBar,
                      onTap: (value) {
                        if(value==2){
                          showAlertDialog(context);
                        }
                        setState(() {
                          _bottomBar = value;
                        });
                      },
                      items: [
                        BottomNavigationBarItem(
                            label: 'Test', icon: Icon(Icons.person_rounded)),
                        BottomNavigationBarItem(
                            label: 'Test', icon: Icon(Icons.person_rounded)),
                        BottomNavigationBarItem(
                            label: 'SignOut', icon: Icon(Icons.logout)),
                      ],
                    ),
                    appBar: AppBar(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      bottom: TabBar(
                        indicatorColor: KmainColor,
                        onTap: (value) {
                          setState(() {
                            _tabBar = value;
                          });
                        },
                        tabs: [
                          Text(
                            'Jackets',
                            style: TextStyle(
                              color:
                                  _tabBar == 0 ? Colors.black : kUnActiveColor,
                              fontSize: _tabBar == 0 ? 16 : null,
                            ),
                          ),
                          Text(
                            'T-shirts',
                            style: TextStyle(
                              color:
                                  _tabBar == 1 ? Colors.black : kUnActiveColor,
                              fontSize: _tabBar == 1 ? 16 : null,
                            ),
                          ),
                          Text(
                            'Trouser',
                            style: TextStyle(
                              color:
                                  _tabBar == 2 ? Colors.black : kUnActiveColor,
                              fontSize: _tabBar == 2 ? 16 : null,
                            ),
                          ),
                          Text(
                            'shoes',
                            style: TextStyle(
                              color:
                                  _tabBar == 3 ? Colors.black : kUnActiveColor,
                              fontSize: _tabBar == 3 ? 16 : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        mybuilder(kJackets, _products),
                        mybuilder(kTshirt, _products),
                        mybuilder(kTrouser, _products),
                        mybuilder(kShoes, _products),
                      ],
                    ),
                  )),
              Material(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Discover'.toUpperCase(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, CartScreen.id);
                          },
                            child: Icon(Icons.shopping_cart))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }



  void showAlertDialog(context)async {
    Auth _auth= Auth();
    AlertDialog alertDialog= AlertDialog(
      actions: [
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('No')),
        FlatButton(onPressed: ()async{
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.clear();
          _auth.signOut();
          Navigator.popAndPushNamed(context, LoginScreen.id);
        }, child: Text('Yes'))
      ],
      title: Text('Are You Sure ?'),);
    await showDialog(context: context,builder: (context){
      return alertDialog;
    });

  }




  @override
  void initState() {
    getCurrentUser();

  }

  getCurrentUser() async {
    _loggedUser = await _auth.getUser();
  }
}

class mybuilder extends StatefulWidget {
  final String category;
  final List<Product> alllist;
  mybuilder(this.category, this.alllist);
  @override
  _mybuilderState createState() => _mybuilderState();
}

class _mybuilderState extends State<mybuilder> {
  List<Product> products = new List<Product>();

  @override
  void initState() {
    try{
      for (Product item in widget.alllist )
        if (item.pCategory == widget.category)
          products.add(item);
    }catch(e){
      print(e);
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return products != null
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: .9),
            itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductInfo.id,
                          arguments: products[index]);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
            itemCount: products.length)
        : Container();

  }





}

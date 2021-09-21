
import 'package:buy_it/Model/product.dart';
import 'package:buy_it/Widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final Firestore _firestore = Firestore.instance;

  addProduct(Product product) {
    _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDescription,
      kProductCategory: product.pCategory,
      kProductLocation: product.pLocation
    });
  }

  Stream<QuerySnapshot> loadProducts(){
     return _firestore.collection(kProductsCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrders(){
    return _firestore.collection(kOrders).snapshots();
  }
  Stream<QuerySnapshot> loadOrdersDetails(documantID){
    return _firestore.collection(kOrders).document(documantID).collection(kOrderDetails).snapshots();
  }


  DeleteProduct(documentId){
    _firestore.collection(kProductsCollection).document(documentId).delete();
  }

  editProduct(data,documentId){
    _firestore.collection(kProductsCollection).document(documentId).updateData(data);
  }
  OrderProduct(data,List<Product> products){
   var documentRef= _firestore.collection(kOrders).document();
   documentRef.setData(data);
   for(var product in products){
     documentRef.collection(kOrderDetails).document().setData({
       kProductName:product.pName,
       kProductPrice:product.pPrice,
       kProductQuantity:product.pQuantity,
       kProductLocation:product.pLocation,
       kProductCategory:product.pCategory,
     });
   }
  }
}


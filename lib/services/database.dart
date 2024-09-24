// // contains all firebase functions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addAllProducts(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .add(userInfoMap);
  }

  Future addProduct(
      Map<String, dynamic> userInfoMap, String categoryname) async {
    return await FirebaseFirestore.instance
        .collection(categoryname)
        .add(userInfoMap);
  }

  UpdateStatus(String id) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(id)
        .update({"status": "Delivered"});
  }

  Future<Stream<QuerySnapshot>> getProducts(String catagory) async {
    return await FirebaseFirestore.instance.collection(catagory).snapshots();
  }

  Future<Stream<QuerySnapshot>> allOrders() async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: "On the way!")
        .snapshots();
  }

  // Future orderDetails(Map<String, dynamic> userInfoMap) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Orders")
  //       .add(userInfoMap);
  // }

  Future<Stream<QuerySnapshot>> getOrders(String email) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .where("Email", isEqualTo: email)
        .snapshots();
  }

  Future<QuerySnapshot> search(String updatedname) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .where("SearchKey",
            isEqualTo: updatedname.substring(0, 1).toUpperCase())
        .get();
  }
}

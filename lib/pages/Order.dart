import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_medix_app/services/database.dart';
import 'package:edu_medix_app/services/shared_pref.dart';
import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;

  getthesharedpref() async {
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  Stream? orderStream;

  getontheload() async {
    await getthesharedpref();
    orderStream = await DatabaseMethods().getOrders(email!);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  // Add logic to return the appropriate widget for each item
                  return Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20.0, top: 10.0, bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Image.network(
                              ds["productImage"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            // Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ds["productName"],
                                    style: AppWidget.semiboldTextFieldStyle(),
                                  ),
                                  Text(
                                    "\৳" + ds["productPrice"],
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 224, 53, 110),
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                   Text(
                                    "[Status - " + ds["status"]+"]",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 229, 44, 44),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ); // Replace with actual item widget
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(244, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(244, 255, 255, 255),
        title: Text(
          "Current Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [Expanded(child: allOrders())],
        ),
      ),
    );
  }
}

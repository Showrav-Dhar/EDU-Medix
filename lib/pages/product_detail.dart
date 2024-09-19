import 'dart:convert';

import 'package:edu_medix_app/services/constant.dart';
import 'package:edu_medix_app/services/shared_pref.dart';
import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  String image, name, detail, price;
  ProductDetails(
      {required this.detail,
      required this.image,
      required this.name,
      required this.price});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map<String, dynamic>? paymentIntent;

  String? name, mail;

  getthesharedpref()async{
    name = await SharedPreferenceHelper().getUserName();
    mail = await SharedPreferenceHelper().getUserEmail();
    setState(() {
      
    });
  }

  ontheload()async{
    await getthesharedpref();
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                ),
                Center(
                  child: Image.network(
                    widget.image,
                    height: 200,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.boldTextFieldStyle(),
                        ),
                        Text(
                          "\৳" + widget.price,
                          style: TextStyle(
                            color: Color.fromARGB(255, 224, 53, 110),
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Details",
                      style: AppWidget.semiboldTextFieldStyle(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(widget.detail),
                    SizedBox(
                      height: 90.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        // makePayment(widget.price);
                        placeOrder();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 224, 53, 110),
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                          // "Buy Now",
                          "Place Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // from claude
  Future<void> placeOrder() async {
  try {
    await FirebaseFirestore.instance.collection('orders').add({
      'productName': widget.name,
      'productPrice': widget.price,
      'orderDate': FieldValue.serverTimestamp(),
      'Name':name,
      'Email':mail,
      'productImage': widget.image,
      // Add more fields as needed, such as user ID, quantity, etc.
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed successfully!')),
    );
  } catch (e) {
    print('Error placing order: $e');
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to place order. Please try again.')),
    );
  }
}
  // dumped this following code 
  // Future<void> makePayment(String amount) async {
    // try {
    //   paymentIntent = await createPayementIntent(amount, 'INR');
    //   await Stripe.instance
    //       .initPaymentSheet(
    //           paymentSheetParameters: SetupPaymentSheetParameters(
    //               paymentIntentClientSecret: paymentIntent?['client_secret'],
    //               style: ThemeMode.dark,
    //               merchantDisplayName: 'Showrav'))
    //       .then((value) {});

    //   displayPaymentSheet();
    // } catch (e, s) {
    //   print('exception:$e$s');
    // }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) async {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.check_circle,
  //                           color: Colors.green,
  //                         ),
  //                         Text("Payment Successful")
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ));
  //       paymentIntent = null;
  //     }).onError((error, StackTrace) {
  //       print("Error is : --->> $error $StackTrace");
  //     });
  //   } on StripeException catch (e) {
  //     print("Error is :--->>> $e");
  //     showDialog(
  //         context: context,
  //         builder: (_) => AlertDialog(
  //               content: Text("Cancelled"),
  //             ));
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  // createPayementIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'cart'
  //     };

  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         'Authorization': 'Bearer $secretkey',
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: body,
  //     );
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     print('err chargin user:${err.toString()}');
  //   }
  // }

  // calculateAmount(String amount) {
  //   final calculatedAmount = (int.parse(amount) * 100);
  //   return calculatedAmount.toString();
  // }
}

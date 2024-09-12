import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_medix_app/pages/product_detail.dart';
import 'package:edu_medix_app/services/database.dart';
import 'package:flutter/material.dart';

import '../widget/support_widget.dart';

class CategoryProduct extends StatefulWidget {
  String catagory;
  CategoryProduct({required this.catagory});

  @override
  State<CategoryProduct> createState() => CategoryProductState();
}

class CategoryProductState extends State<CategoryProduct> {
  Stream? categoryStream;

  getontheload() async {
    categoryStream = await DatabaseMethods().getProducts(widget.catagory);

    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
      stream: categoryStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  // Add logic to return the appropriate widget for each item
                  return Container(

                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(height: 10.0,),
                        Image.network(
                          ds["Image"],
                          height: 100,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10.0,),
                        Text(
                          ds["Name"],
                          style: AppWidget.semiboldTextFieldStyle().copyWith(fontSize: 15),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "\৳" + ds["Price"],
                              style: TextStyle(
                                  color: Color.fromARGB(255, 224, 53, 110),
                                  fontSize: 22.5,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(detail: ds["Detail"], image: ds["Image"], name: ds["Name"], price: ds["Price"])));
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 224, 53, 110),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        )
                      ],
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
      backgroundColor: const Color.fromARGB(244, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(244, 255, 255, 255),
        title: const Text('Category Products'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0,right: 20.0),
        child: Column(
          children: [
            
            Expanded(child: allProducts()),
          ],
        ),
      ),
    );
  }
}

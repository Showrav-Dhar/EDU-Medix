import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/support_widget.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({super.key});

  @override
  State<CategoryProduct> createState() => CategoryProductState();
}

class CategoryProductState extends State<CategoryProduct> {
  Stream? categoryStream;

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
                    margin: EdgeInsets.only(right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Image.network(
                          ds[Image],
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          ds[name],
                          style: AppWidget.semiboldTextFieldStyle(),
                        ),
                        Row(
                          children: [
                            Text(
                              "\৳৩০০০",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 224, 53, 110),
                                  fontSize: 22.5,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 224, 53, 110),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ))
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
        child: Column(
          children: [
            // Add children widgets here
            allProducts(),
          ],
        ),
      ),
    );
  }
}

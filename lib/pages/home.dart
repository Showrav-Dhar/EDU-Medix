import 'package:edu_medix_app/pages/category_products.dart';
import 'package:edu_medix_app/pages/product_detail.dart';
import 'package:edu_medix_app/services/database.dart';
import 'package:edu_medix_app/services/shared_pref.dart';
import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;

  String timeGreeting = "";

  // @override
  // void initState() {
  //   super.initState();
  //   print("initState called"); // Debug print
  //   _updateTimeGreeting();
  // }

  void _updateTimeGreeting() {
    var hour = DateTime.now().hour;
    // print("Current hour: $hour"); // Debug print
    setState(() {
      if (hour < 12) {
        timeGreeting = "Good morning";
      } else if (hour < 17) {
        timeGreeting = "Good afternoon";
      } else {
        timeGreeting = "Good evening";
      }
      // print("Time greeting updated: $timeGreeting"); // Debug print
    });
  }

  List catagories = [
    "images/catagory/medicine.png",
    "images/catagory/Beverages.png",
    "images/catagory/Toiletries.png",
    "images/catagory/Medical_Equipment.png",
  ];

  List<Map<String, String>> categories = [
    {"image": "images/catagory/medicine.png", "name": "Medicines"},
    {"image": "images/catagory/Beverages.png", "name": "Beverages"},
    {"image": "images/catagory/Toiletries.png", "name": "Toiletries"},
    {
      "image": "images/catagory/Medical_Equipment.png",
      "name": "Medical Equipment"
    },
    // Add more categories as needed
  ];

  List Catagoryname = [
    'Medicines',
    'Beverages',
    'Toiletries',
    'Medical_Equipment'
  ];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  // to show all the products
  List<DocumentSnapshot> products = [];

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  void fetchProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Products').get();
    setState(() {
      products = querySnapshot.docs;
    });
  }

  @override
  void initState() {
    _updateTimeGreeting();
    ontheload();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(244, 255, 255, 255),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey, " + name!,
                            style: AppWidget.boldTextFieldStyle(),
                          ),
                          Text(
                            timeGreeting.isEmpty
                                ? "Greeting placeholder"
                                : timeGreeting,
                            style: AppWidget.lightTextFieldStyle() ??
                                TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          // Text(
                          //     "Debug: Current hour: ${DateTime.now().hour}, timeGreeting: $timeGreeting"), // Add this line for debugging
                        ],
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "images/user_image.png",
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: searchcontroller,
                        onChanged: (value) {
                          initiateSearch(value.toUpperCase());
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search Products",
                          hintStyle: AppWidget.lightTextFieldStyle(),
                          prefixIcon: search
                              ? GestureDetector(
                                  onTap: () {
                                    search = false;
                                    tempSearchStore = [];
                                    queryResultSet = [];
                                    searchcontroller.text = "";
                                    setState(() {});
                                  },
                                  child: Icon(Icons.close))
                              : Icon(Icons.search, color: Colors.black),
                        ),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  search
                      ? ListView(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildResultCard(element);
                          }).toList(),
                        )
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Catagories",
                                    style: AppWidget.semiboldTextFieldStyle()),
                                // Text(
                                //   "View All",
                                //   style: TextStyle(
                                //       color: Color.fromARGB(255, 224, 53, 110),
                                //       fontSize: 20.0,
                                //       fontWeight: FontWeight.w500),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: [
                                Container(
                                  // All button
                                  height: 100,
                                  margin: EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 224, 53, 110),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // height: 90,
                                  width: 50,
                                  // child: Image.asset(
                                  //   image,
                                  //   fit: BoxFit.contain, // Ensure the image fits
                                  // ),
                                  child: Center(
                                      child: Text(
                                    "All",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 100,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: catagories.length,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        print(
                                            "Building category tile for index $index");
                                        return CatagoryTile(
                                          image: categories[index]['image']!,
                                          name: Catagoryname[index]!,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("All Products",
                                    style: AppWidget.semiboldTextFieldStyle()),
                                // Text(
                                //   "View All",
                                //   style: TextStyle(
                                //       color: Color.fromARGB(255, 224, 53, 110),
                                //       fontSize: 20.0,
                                //       fontWeight: FontWeight.w500),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              height: 190,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "images/Oxymeter.jpeg",
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "Oxymeter",
                                          style: AppWidget
                                              .semiboldTextFieldStyle(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\৳১৫০০",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 224, 53, 110),
                                                  fontSize: 22.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 224, 53, 110),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  // second product
                                  Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "images/blood_pressure_machine.jpeg",
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "BP Checker",
                                          style: AppWidget
                                              .semiboldTextFieldStyle(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\৳৩০০০",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 224, 53, 110),
                                                  fontSize: 22.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 224, 53, 110),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  //third product
                                  Container(
                                    margin: EdgeInsets.only(right: 20.0),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "images/nebulaizer.webp",
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        Text(
                                          "Nebulaizer",
                                          style: AppWidget
                                              .semiboldTextFieldStyle(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "\৳৪০০০",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 224, 53, 110),
                                                  fontSize: 22.5,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                            ),
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 224, 53, 110),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetails(
                    detail: data["Detail"],
                    image: data["Image"],
                    name: data["Name"],
                    price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data["Image"],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              data["Name"],
              style: AppWidget.semiboldTextFieldStyle(),
            )
          ],
        ),
      ),
    );
  }
}

class CatagoryTile extends StatelessWidget {
  final String image;
  final String name;

  CatagoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryProduct(catagory: name)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 172, 205, 237),
          borderRadius: BorderRadius.circular(10),
        ),
        // height: 90,
        width: 90,
        // child: Image.asset(
        //   image,
        //   fit: BoxFit.contain, // Ensure the image fits
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final String price;

  const ProductCard({
    Key? key,
    required this.name,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '৳$price',
                      style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
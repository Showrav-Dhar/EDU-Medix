import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? value;

  final List<String> categoryitem = [
    'Medicines',
    'Oinment',
    'Beverages',
    'Toiletries',
    'Medical_Equipment'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Text(
          "Add Product",
          style: AppWidget.semiboldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload The Product Image",
                style: AppWidget.semiboldTextFieldStyle()),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(Icons.camera_alt),
              ),
            ),
            SizedBox(height: 20.0),
            Text("Upload The Product Name",
                style: AppWidget.semiboldTextFieldStyle()),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 168, 225, 237),
                  borderRadius: BorderRadius.circular(20)),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "Product Catagory",
              style: AppWidget.semiboldTextFieldStyle(),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 168, 225, 237),
                    borderRadius: BorderRadius.circular(20)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: categoryitem
                        .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style: AppWidget.semiboldTextFieldStyle(),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: Text(
                      "Select Catagory",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    iconSize: 35,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                )),
            SizedBox(
              height: 30.0,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Add Product",
                      style: TextStyle(fontSize: 20.0),
                    ))),
          ],
        ),
      ),
    );
  }
}

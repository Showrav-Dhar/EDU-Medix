import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_medix_app/Admin/home_admin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edu_medix_app/widget/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/AdminSignUpPhoto.png"),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  "Admin Panel",
                  style: AppWidget.boldTextFieldStyle(),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // Center(
              //   child: Text(
              //     "Please Enter The Details Below\n                To Continue",
              //     style: AppWidget.lightTextFieldStyle(),
              //   ),
              // ),
              // SizedBox(
              //   height: 10.0,
              // ),
              Text(
                "  Username",
                style: AppWidget.boldTextFieldStyle(),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 216, 238, 238),
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: usernamecontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Enter Your Name"),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "  Password",
                style: AppWidget.boldTextFieldStyle(),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 216, 238, 238),
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  obscureText: true,
                  controller: userpasswordcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Password"),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  loginAdmin();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                        child: Text(
                      "LOG IN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      // to enter in the docs of admin in the firebase database and access admin username and password
      snapshot.docs.forEach((result) {
        if (result.data()['username'] != usernamecontroller.text.trim()) {
          // if user puts space after his username while logging in .trim() will remove the space
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Your ID is not correct",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (result.data()['password'] !=
            userpasswordcontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Your Password is not correct",
                style: TextStyle(fontSize: 20.0),
              )));
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeAdmin()));
        }
      });
    });
  }
}

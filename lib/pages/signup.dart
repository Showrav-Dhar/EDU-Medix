import 'package:edu_medix_app/pages/bottomnav.dart';
import 'package:edu_medix_app/pages/login.dart';
import 'package:edu_medix_app/services/database.dart';
import 'package:edu_medix_app/services/shared_pref.dart';
import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name, email, password;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (password != null && name != null && email != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Registered Successfully!",
              style: TextStyle(fontSize: 20.0),
            )));
        String Id = randomAlphaNumeric(10);

        await SharedPreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(namecontroller.text);
        // await SharedPreferenceHelper().saveUserImage(); // do not have any image - showrav
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": Id,
          "Image":"",
        };

        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Bottomnav()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-passsword') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Password Provided is too weak!",
                style: TextStyle(fontSize: 20.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Account already exists!",
                style: TextStyle(fontSize: 20.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin:
              EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0, bottom: 40),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("images/SignUpPhoto.png"),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "Sign Up",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "Please Enter The Details Below\n                To Continue",
                    style: AppWidget.lightTextFieldStyle(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "  Name",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Name';
                      }

                      return null;
                    },
                    controller: namecontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter Your Name"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "  Email",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Email';
                      }

                      return null;
                    },
                    controller: mailcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Enter Your Email"),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Password';
                      }

                      return null;
                    },
                    controller: passwordcontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Password"),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        name = namecontroller.text;
                        email = mailcontroller.text;
                        password = passwordcontroller.text;
                      });
                    }
                    registration();
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
                        "SIGN UP NOW",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have An Account?  ",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

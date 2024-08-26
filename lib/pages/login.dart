import 'package:edu_medix_app/pages/signup.dart';
import 'package:edu_medix_app/pages/home.dart';
import 'package:edu_medix_app/pages/bottomnav.dart';
import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
String email="", password="";

  TextEditingController mailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin()async{
    try{
      await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      Navigator.push(context, MaterialPageRoute(builder: (context)=>Bottomnav()));
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("No user found for that email", style: TextStyle(fontSize: 20.0),)));
      }
      else if(e.code == 'wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Wrong Passoword Provided by the user", style: TextStyle(fontSize: 20.0),)));
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
                Image.asset("images/LoginPhoto.jpg"),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    "Sign In",
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
                    validator: (value){
                      if(value == null || value.isEmpty){
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
                    controller:passwordcontroller,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Please Enter Your Password';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Password"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: (){
                    if(_formkey.currentState!.validate()){
                      setState((){
                        email=mailcontroller.text;
                        password=passwordcontroller.text;
                      });
                    }
                    userLogin();

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
                        "LOGIN",
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
                      "Don't Have An Account?  ",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp()));
                      },
                      child: Text(
                        "Sign Up",
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

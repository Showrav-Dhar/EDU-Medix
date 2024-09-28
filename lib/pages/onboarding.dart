import 'package:edu_medix_app/pages/bottomnav.dart';
import 'package:edu_medix_app/pages/signup.dart';
import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffecefe8),
      body: Container(
          margin: EdgeInsets.only(top: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("images/EDU_MEDIX.jpg"),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "Daily Medical\nNeeds at your\nDoorstep",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.00,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the next screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20.0),
                      padding: EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.00,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}

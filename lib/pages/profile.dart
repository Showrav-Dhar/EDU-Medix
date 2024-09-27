import 'package:edu_medix_app/widget/support_widget.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(244, 255, 255, 255),
        title: Text(
          "Profile",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      backgroundColor: Color.fromARGB(244, 255, 255, 255),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

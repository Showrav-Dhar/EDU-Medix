import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future SignOut() async{
    await FirebaseAuth.instance.signOut();
  }

  Future deleteuser() async{
    User? user = await FirebaseAuth.instance.currentUser;
    user?.delete();
  }
}
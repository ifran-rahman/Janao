import 'package:dhoro_test/screens/dashboard.dart';
import 'package:dhoro_test/screens/loginpage.dart';
import 'package:dhoro_test/services/authservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

 void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(), //AuthService().handleAuth(),DashboardPage()
    );
  }
}


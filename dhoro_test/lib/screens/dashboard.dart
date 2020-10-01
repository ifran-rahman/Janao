import 'package:dhoro_test/screens/imagecapture.dart';
import 'package:dhoro_test/services/authservice.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Center(
                child: Container(
              height: 200,
              width: 200,
              child: Image(image: AssetImage('assets/janao_logo.png')),
            )),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ButtonTheme(
                minWidth: 230.0,
                height: 70.0,
                child: RaisedButton(
                  elevation: 5,
                  color: Colors.red[600],
                  child: Text(
                    'Report a crime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageCapture()),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ButtonTheme(
                minWidth: 150.0,
                height: 35.0,
                child: RaisedButton(
                  elevation: 5,
                  color: Colors.black38,
                  child: Text(
                    'Signout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    AuthService().signOut();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

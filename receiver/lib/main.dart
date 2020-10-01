import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final _firestore = FirebaseFirestore.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(receiver());
}

class receiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crime Lists',
      theme: new ThemeData(
        primaryColor: Colors.red.shade600,
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Crime List',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore.collection('event').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final crimes = snapshot.data.docs;
                  List<MessageBubble> messageBubbles = [];
                  for (var crime in crimes) {
                    final messageText = crime.data()['description'];
                    final messageSender = crime.data()['phone'];
                    final image = crime.data()['image'];
                    final latitude = crime.data()['latitude'];
                    final longitude = crime.data()['longitude'];

                    final messageBubble = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      image: image,
                      longitude: longitude.toString(),
                      latitude: latitude.toString(),
                    );
                    messageBubbles.add(messageBubble);
                  }

                  return Expanded(
                    child: ListView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        children: messageBubbles),
                  );
                }
              })
        ],
      )),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final String image;
  final String latitude;
  final String longitude;

  const MessageBubble(
      {Key key,
      this.sender,
      this.text,
      this.image,
      this.latitude,
      this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              elevation: 2,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                    child: Text(
                      sender,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.network(
                    '$image',
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Description:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$text',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'latitude:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$longitude',
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'longitude:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '$longitude',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

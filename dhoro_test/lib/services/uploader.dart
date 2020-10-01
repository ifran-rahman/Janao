import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:dhoro_test/services/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhoro_test/screens/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://testing-f5569.appspot.com');
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  StorageUploadTask _uploadTask;
  Location location;
  var url;
  LoginPage loginPage;
  User loggedInUser;
  String description;

  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  /// Starts an upload task
  Future<String> _startUpload() async {
    /// Unique file name for the file
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
    //Download and store url to url variable
    var downUrl = await (await _uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    // Get position
    Position position;
    position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("$position.latitude --- $position.longitude");

    _firestore.collection('event').add({
      'image': url,
      'latitude': position.latitude.toString(),
      'longitude': position.longitude.toString(),
      'phone': loggedInUser.phoneNumber,
      'time': Timestamp.now(),
      'description': this.description,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (_, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
              children: [
                if (_uploadTask.isComplete) Text('🎉🎉🎉'),

                if (_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),

                if (_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Details',

                ),
                onChanged: (text) {
                  setState(() {
                    this.description = text;
                  });
                },
              )),
          FlatButton.icon(
            label: Text('Report'),
            icon: Icon(Icons.cloud_upload),
            onPressed: _startUpload,
          ),
        ],
      );
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventViewPage extends StatefulWidget {
  @override
  _EventViewPageState createState() => new _EventViewPageState();
  final String text;
  EventViewPage({Key key, @required this.text}) : super(key: key);
}

class _EventViewPageState extends State<EventViewPage> {
  CollectionReference event = FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("asd"),
          backgroundColor: Colors.purple[900],
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: event.doc('J8slsYdNRfOKGGZScbjc').get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return Container(
                  padding: const EdgeInsets.all(20),
                  height: 500,
                  width: 500,
                  child: Text(
                    "Full Name:" + data['title'].toString(),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ));
            }

            return Text("loading");
          },
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenimentApp/Pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/scheduler.dart';

import 'dart:math';
import 'package:flip_card/flip_card.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => new _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  @override
  bool wi = false;
  List<dynamic> arr = [''];
  List<dynamic> topics = ['sport', 'art', 'concert', 'food'];
  void initState() {
    getUser();
    super.initState();
  }

  DocumentSnapshot doci;
  getUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final String id = uid;
    final doci = await usersRef.doc(id).get();
    print(doci.data());

    print(doci.data());
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    String test = "";

    getUser();

    var cardAspectRatio = 12.0 / 16.0;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    print(test);
    var data;

    void ad() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        arr = documentSnapshot['event'];
        topics = await documentSnapshot['topics'];
        print(arr);
      });
    }

    print(test);

    Future<void> add(x) {
      if (arr.contains(x)) {
      } else {
        arr.add(x);
      }
      return users
          .doc(uid)
          .update({'event': arr})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    arr.add(uid);

    int i = 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[900],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('events')
              .where("organizer", isEqualTo: uid)
              // .orderBy('date')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              ad();
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              ad();
            }

            return ListView(
              padding: const EdgeInsets.all(8),
              children: snapshot.data.docs.map((document) {
                return Container(
                    padding: const EdgeInsets.all(8),
                    child: FlipCard(
                      front: Container(
                        // padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(3.0, 6.0),
                                      blurRadius: 10.0)
                                ]),
                            child: AspectRatio(
                              aspectRatio: cardAspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Image.network(document['image'],
                                      fit: BoxFit.cover),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Text(document['title'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily:
                                                      "SF-Pro-Text-Regular")),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      back: Container(
                        // padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(3.0, 6.0),
                                      blurRadius: 10.0)
                                ]),
                            child: AspectRatio(
                              aspectRatio: cardAspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Image.network(document['image'],
                                      color: Color.fromRGBO(255, 255, 255, 0.5),
                                      colorBlendMode: BlendMode.modulate,
                                      fit: BoxFit.cover),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 20.0),
                                          child: Text(document['description'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily:
                                                      "SF-Pro-Text-Regular")),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Text(document['title'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily:
                                                      "SF-Pro-Text-Regular")),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
              }).toList(),
            );
          }),
    );
  }

  // Future<void> viewEvent() {
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => EventViewPage()));
  // }
}

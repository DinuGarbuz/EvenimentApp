import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../events.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
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

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isSwitchedSport = false;
  bool isSwitchedArt = false;
  bool isSwitchedConcert = false;
  bool isSwitchedFood = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    var cardAspectRatio = 2.0 / 2.0;
    List<dynamic> arr = [''];
    List<dynamic> topics = ['sport', 'art', 'concert', 'food'];

    String test = "";

    getUser();

    void ad() {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        arr = await documentSnapshot['topics'];
        print(arr);
      });
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      arr = documentSnapshot['topics'];
      print(arr);
    });

    print(arr);
    if (arr.contains('sport')) {
      isSwitchedSport = true;
    }
    if (arr.contains('art')) {
      isSwitchedArt = true;
    }
    if (arr.contains('concert')) {
      isSwitchedConcert = true;
    }
    if (arr.contains('food')) {
      isSwitchedFood = true;
    }

    Future<void> add(x) {
      if (arr.contains(x)) {
        arr.remove(x);
      } else {
        arr.add(x);
      }

      return users
          .doc(uid)
          .update({'topics': arr})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("My Profile"),
            backgroundColor: Colors.purple[900],
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventsPage()));
                },
              )
            ]),
        body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              ad();
              return Text("Something went wrong");
            } else {
              ad();
            }

            if (snapshot.connectionState == ConnectionState.done) {
              ad();
              if (arr.contains('sport')) {
                isSwitchedSport = true;
              }
              if (arr.contains('art')) {
                isSwitchedArt = true;
              }
              if (arr.contains('concert')) {
                isSwitchedConcert = true;
              }
              if (arr.contains('food')) {
                isSwitchedFood = true;
              }
              Map<String, dynamic> data = snapshot.data.data();
              return Container(
                  padding: EdgeInsets.only(top: 1.0),
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                        Container(
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
                                    Image.network(
                                        'https://st3.depositphotos.com/15648834/17930/v/600/depositphotos_179308454-stock-illustration-unknown-person-silhouette-glasses-profile.jpg',
                                        fit: BoxFit.cover),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Subscribe:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          color: Colors.white24,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[Text('Sport')],
                                ),
                                Column(
                                  children: <Widget>[
                                    Center(
                                      child: Switch(
                                        value: isSwitchedSport,
                                        onChanged: (value) {
                                          add('sport');
                                          setState(() {
                                            isSwitchedSport = value;
                                            print(isSwitchedSport);
                                            print(value);
                                          });
                                        },
                                        activeTrackColor: Colors.purple[100],
                                        activeColor: Colors.purple,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                        Container(
                          color: Colors.white24,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[Text('Art')],
                                ),
                                Column(
                                  children: <Widget>[
                                    Center(
                                      child: Switch(
                                        value: isSwitchedArt,
                                        onChanged: (value) {
                                          add('art');
                                          setState(() {
                                            isSwitchedArt = value;
                                            print(isSwitchedArt);
                                            print(value);
                                          });
                                        },
                                        activeTrackColor: Colors.purple[100],
                                        activeColor: Colors.purple,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                        Container(
                          color: Colors.white24,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[Text('Concert')],
                                ),
                                Column(
                                  children: <Widget>[
                                    Center(
                                      child: Switch(
                                        value: isSwitchedConcert,
                                        onChanged: (value) {
                                          add('concert');
                                          setState(() {
                                            isSwitchedConcert = value;
                                            print(isSwitchedConcert);
                                            print(value);
                                          });
                                        },
                                        activeTrackColor: Colors.purple[100],
                                        activeColor: Colors.purple,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                        Container(
                          color: Colors.white24,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[Text('Food')],
                                ),
                                Column(
                                  children: <Widget>[
                                    Center(
                                      child: Switch(
                                        value: isSwitchedFood,
                                        onChanged: (value) {
                                          setState(() {
                                            add('food');
                                            isSwitchedFood = value;
                                            print(isSwitchedFood);
                                            print(value);
                                          });
                                        },
                                        activeTrackColor: Colors.purple[100],
                                        activeColor: Colors.purple,
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        ),
                      ])));
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}

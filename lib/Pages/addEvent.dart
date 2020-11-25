import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../events.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => new _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _title, _type, _organizer, _location, _description, _image;
  String _date;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    String role;

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      role = documentSnapshot['role'];

      print(role);
    });

    CollectionReference event = FirebaseFirestore.instance.collection('events');

    Future<void> addEvent() {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        Navigator.pop(context);

        if (role == "admin") {
          // Call the user's CollectionReference to add a new user
          return event
              .add({
                'title': _title,
                'type': _type,
                'location': _location,
                'organizer': uid,
                'date': _date,
                'description': _description,
                'image': _image
              })
              .then((value) => print("Event Added"))
              .catchError((error) => print("Failed to add event: $error"));
        } else {
          return event
              .add({
                'title': _title,
                'type': uid,
                'location': _location,
                'organizer': uid,
                'date': _date,
                'description': _description,
                'image': _image
              })
              .then((value) => print("Event Added"))
              .catchError((error) => print("Failed to add event: $error"));
        }
      }
    }

    return Scaffold(
        appBar: new AppBar(
          title: Text("Add new event"),
          backgroundColor: Colors.purple[900],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a title';
                      }
                    },
                    onSaved: (input) => _title = input,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a description';
                      }
                    },
                    onSaved: (input) => _description = input,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Image URL",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide an image URL';
                      }
                    },
                    onSaved: (input) => _image = input,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "type",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a type';
                      }
                    },
                    onSaved: (input) => _type = input,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Location",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a location';
                      }
                    },
                    onSaved: (input) => _location = input,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Provide a date';
                      }
                    },
                    onSaved: (input) => _date = input,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      height: 40,
                      width: 250,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.purple[900]),
                      child: Center(
                        child: FlatButton(
                          color: Colors.purple[900],
                          onPressed: addEvent,
                          child: Text(
                            'Add',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                backgroundColor: Colors.purple[900]),
                          ),
                        ),
                      )),
                ],
              )),
        ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => new _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _age, _number, _location;
  String _date;
  List<dynamic> arr = [''];
  List<dynamic> topics = [''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide a name';
                  }
                },
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (input) => _name = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide age';
                  }
                },
                decoration: InputDecoration(labelText: 'Age'),
                onSaved: (input) => _age = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide a location';
                  }
                },
                decoration: InputDecoration(labelText: 'Location'),
                onSaved: (input) => _location = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an date';
                  }
                },
                decoration: InputDecoration(labelText: 'Date'),
                onSaved: (input) => _date = input,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Provide an organizer';
                  }
                },
                decoration: InputDecoration(labelText: 'Number'),
                onSaved: (input) => _number = input,
              ),
              FlatButton(
                onPressed: addEvent,
                child: Text(
                  "Add ",
                ),
              ),
            ],
          )),
    );
  }

  CollectionReference event = FirebaseFirestore.instance.collection('users');

  Future<void> addEvent() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context);

      // Call the user's CollectionReference to add a new user
      return event
          .add({
            'name': _name,
            'age': _age,
            'events': arr,
            'role': 'user',
            'topics': topics
          })
          .then((value) => print("Event Added"))
          .catchError((error) => print("Failed to add event: $error"));
    }
  }
}

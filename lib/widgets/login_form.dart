import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/transaction_screen.dart';

class LoginForm extends StatefulWidget {
  // static const routeName = "/login-screen-form";
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  User db;

  List userList = [];
  List filterList = [];

  var index;

  initialise() {
    db = User();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            userList = value;
          })
        });

    print(userList);
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  TextEditingController _customerIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _form = GlobalKey<FormState>();
  TextStyle style = TextStyle(
    fontFamily: 'latto',
    fontSize: 20.0,
    color: Colors.white,
  );

  login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    filterList = userList
        .where((element) => (element['custId']
            .toLowerCase()
            .contains(_customerIdController.text.toLowerCase())))
        .toList();

    if (filterList.isNotEmpty &&
        filterList[0]['custId'] == _customerIdController.text) {
      if (filterList[0]['phoneNo'] == _passwordController.text) {
        sharedPreferences.setString("user", json.encode(filterList[0]));

        String token = await FirebaseMessaging.instance.getToken();
      
        if(filterList[0]['token'] == "" || filterList[0]['token'] == null){

            FirebaseFirestore.instance
            .collection('user')
            .doc(filterList[0]['id'])
            .set({'token': token}, SetOptions(merge: true));
        }
        

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => TransactionScreen()),
            (Route<dynamic> route) => false);
      } else {
        final snackBar = SnackBar(
          content: const Text('Wrong password!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: const Text('Customer id is invalid!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _form,
        child: Container(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(children: <Widget>[
            TextFormField(
              controller: _customerIdController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide Valid customer id.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Customer Id",
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.left,
              // controller: _emailController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              obscureText: false,
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.orangeAccent),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Material(
              elevation: 1.0,
              borderRadius: BorderRadius.circular(12.0),
              color: Theme.of(context).accentColor,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  // Navigator.of(context).pushNamed(TransactionScreen.routeName);
                  login();
                },
                child: Text("Login",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

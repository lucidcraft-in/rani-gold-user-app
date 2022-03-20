import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './home_screen.dart';
import './login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/transaction_list.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = "/transaction-screen";

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var user;

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      user = jsonDecode(prefs.getString('user'));
    });

    // user = prefs.containsKey('user');
  }

  @override
  Widget build(BuildContext context) {
    // Clear shared preferance
    logout() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.getKeys();
      for (String key in preferences.getKeys()) {
        preferences.remove(key);
      }
      setState(() {});
      // Navigate Page
      // Navigator.of(context).pushNamed(HomeScreen.routeName);
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new HomeScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                new MaterialPageRoute(builder: (context) => new HomeScreen()));
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
        ),
        title: Text(
          "TRANSACTIONS",
          style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'latto',
              fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('! Log out '),
                  // content: Text('Log out of Angadi'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Log Out'),
                      onPressed: () {
                        logout();
                      },
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 35),
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 20, left: 18, right: 18),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 6,
                    child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          // side: BorderSide(
                          //   color: Colors.purple.withOpacity(0.2),
                          //   width: 1,
                          // ),
                        ),
                        color: Colors.grey[50],
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              // padding: EdgeInsets.all(5),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 10, left: 30),
                                    child: Container(
                                      child: Text(
                                        "Available balance is",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'latto'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.piggyBank,
                                        size: 17,
                                        color: Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        user != null
                                            ? " + ₹ ${user['balance'].toString()}"
                                            : " + ₹ 00",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'latto',
                                            fontSize: 15),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Last updated at",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'latto',
                                        color: Colors.grey[400]),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "january, 27, 2022",
                                        style: TextStyle(
                                            fontFamily: 'latto',
                                            fontSize: 11,
                                            color: Colors.grey),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: [
                    Text(
                      "Transaction List",
                      style: TextStyle(
                        fontFamily: 'latto',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 30,
                thickness: 0,
                indent: 0,
                endIndent: 0,
                color: Colors.black12,
              ),
              TransactionList(),
            ],
          ),
        ),
      ),
    );
  }
}

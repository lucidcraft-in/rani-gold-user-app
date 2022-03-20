import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
  import '../Providers/goldrate.dart';
import '../providers/storage_service.dart';
import './slider_page.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Storage storage = Storage();
  Goldrate db;

  List goldrateList = [];

  initialise() {
    db = Goldrate();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
           
            goldrateList = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 130,
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        // side: BorderSide(
                        //   color: Colors.purple.withOpacity(0.2),
                        //   width: 1,
                        // ),
                      ),
                      color: Theme.of(context).accentColor,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Today's Gold Rate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[900],
                                      fontFamily: 'Lato'),
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'PER GRAM',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  Text(
                                    '8 GRAM',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  Text((() {
                                    if (goldrateList.length > 0 &&
                                        goldrateList[0]['down'] == 0) {
                                      return "Up";
                                    } else {
                                      return "Down";
                                    }
                                  }())),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    '₹ ${goldrateList.length > 0 ? goldrateList[0]['gram'].toString() : '00'}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '₹ ${goldrateList.length > 0 ? goldrateList[0]['pavan'].toString() : '00'}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    (() {
                                      if (goldrateList.length > 0 &&
                                          goldrateList[0]['down'] == 0) {
                                        return '₹ ${goldrateList.length > 0 ? goldrateList[0]['up'].toString() : '00'}';
                                      } else {
                                        return '₹ ${goldrateList.length > 0 ? goldrateList[0]['down'].toString() : '00'}';
                                      }
                                    }()),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                )
              ],
            ),
            // SizedBox(height: 40,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  kBottomNavigationBarHeight -
                  210,
              padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 5),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                color: Colors.grey[50],
                // child: imageSlider(context),
                child: SliderPage(),
              ),
            )
          ],
        ));
  }
}


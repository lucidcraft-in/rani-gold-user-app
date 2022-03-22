import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/transaction.dart';

class TransactionList extends StatefulWidget {
  static const routeName = "/transaction_list";

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  var user;
  Transaction db;
  List transactionList = [];
  initialise() {
    db = Transaction();
    db.initiliase();
    db.read(user['id']).then((value) => {
          setState(() {
            transactionList = value;
          })
        });

    print("check trans list");
    print(transactionList);
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    user = jsonDecode(prefs.getString('user'));
    print(user['id']);
    await initialise();
    // user = prefs.containsKey('user');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: transactionList != null
            ? ListView.builder(
                 itemCount: transactionList.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime myDateTime =
                                  (transactionList[index]['date']).toDate();
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        color: Colors.grey[200],
                        width: double.infinity,
                        height: 25,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                          DateFormat.yMMMd()
                                              .add_jm()
                                              .format(myDateTime)
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )),
                      ),
                      Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 30,right: 5,bottom: 5,top: 5),
                                          width:
                                              MediaQuery.of(context).size.width /
                                                  1.0,
                                          child: Row(
                                            children: [
                                              Text(" "),
                                               Expanded(
                                                  child: Text(
                                              "Invoice No :",
                                                style: TextStyle(
                                                    fontFamily: 'latto',
                                                    fontSize: 11,
                                                    color: Colors.black87),
                                              )),
                                              Expanded(
                                                  child: Text(
                                              transactionList[index]['invoiceNo'] != null ?   transactionList[index]['invoiceNo']: "",
                                                style: TextStyle(
                                                    fontFamily: 'latto',
                                                    fontSize: 13,
                                                    color: Colors.black87),
                                              )),
                                              Expanded(
                                                  child: Text(
                                              "Category :",
                                                style: TextStyle(
                                                    fontFamily: 'latto',
                                                    fontSize: 11,
                                                    color: Colors.black87),
                                              )),
                                              Expanded(
                                                  child: Text(
                                               transactionList[index]['category'] != null ?  transactionList[index]['category']: "",
                                                style: TextStyle(
                                                    fontFamily: 'latto',
                                                    fontSize: 13,
                                                    color: Colors.black87),
                                              )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: transactionList[index]
                                                          ['transactionType'] ==
                                                      0
                                                  ? FaIcon(
                                                      FontAwesomeIcons
                                                          .plusCircle,
                                                      size: 22,
                                                      color: Colors.green[700],
                                                    )
                                                  : FaIcon(
                                                      FontAwesomeIcons
                                                          .minusCircle,
                                                      size: 22,
                                                      color: Colors.red[700],
                                                    ),
                                            ),
                                Expanded(
                                    child: Text(
                                   transactionList[index]['note'],
                                  style: TextStyle(
                                      fontFamily: 'latto',
                                      fontSize: 13,
                                      color: Colors.black87),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 4.0,left: 4.0,bottom: 4.0,right: 12.0),
                            width: 100.0,
                            child: Text(
                              " ₹ ${transactionList[index]['amount'].toString()}",
                                textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "latto",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                })
            : Center(
                child: EmptyWidget(
   image: null,
   packageImage: PackageImage.Image_1,
   title: 'No data found',
   subTitle: 'No  transaction available yet',
   titleTextStyle: TextStyle(
     fontSize: 22,
     color: Color(0xff9da9c7),
     fontWeight: FontWeight.w500,
   ),
   subtitleTextStyle: TextStyle(
     fontSize: 14,
     color: Color(0xffabb8d6),
   ),
 ),
              ),
      ),
    );
  }
}

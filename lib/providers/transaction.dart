import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TransactionModel {
  final String id;
  final String customerName;
  final String customerId;
  final DateTime date;
  final double amount;
  final int transactionType;
  final String note;

  TransactionModel({
    @required this.id,
    @required this.customerName,
    @required this.customerId,
    @required this.date,
    @required this.amount,
    @required this.transactionType,
    @required this.note,
  });

  TransactionModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        customerName = data['customerName'],
        customerId = data['customerId'],
        date = data['date'],
        amount = data['amount'],
        transactionType = data['transactionType'],
        note = data['note'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerId': customerId,
      'date': date,
      'amount': amount,
      'transactionType': transactionType,
      'note': note,
    };
  }
}

class Transaction with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('transactions');

  CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection('user');

  List<TransactionModel> _transaction;
  double newbalance = 0;
  double oldBalance = 0;
 
  

  Future<List> read(String id) async {
    QuerySnapshot querySnapshot;
    List transactionList = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp',descending:true ).get();

      if (querySnapshot.docs.isNotEmpty) {
        print("inside read trasaction");
        for (var doc in querySnapshot.docs.toList()) {
        
          if (id == doc['customerId']) {
            Map a = {
              "id": doc.id,
              'customerName': doc['customerName'],
              'customerId': doc['customerId'],
              'date': doc['date'],
              'amount': doc['amount'],
              'transactionType': doc['transactionType'],
              'note': doc['note'],
            };
            transactionList.add(a);
          }
        }

        return transactionList;
      }
    } catch (e) {
      print(e);
    }
  }
}

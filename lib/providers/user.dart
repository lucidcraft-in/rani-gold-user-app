import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String custId;
  final String phoneNo;
  final String address;
  final String place;
  final double balance;
  final String token;

  UserModel({
    @required this.id,
    @required this.name,
    @required this.custId,
    @required this.phoneNo,
    @required this.address,
    @required this.place,
    @required this.balance,
    @required this.token,
  });

  UserModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        custId = data['cust_id'],
        phoneNo = data['phonne_no'],
        address = data['address'],
        place = data['place'],
        balance = data['balance'],
         token = data['token'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cust_id': custId,
      'phone_no': phoneNo,
      'address': address,
      'place': place,
      'balance': balance,
       'token': token,
    };
  }
}

class User with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('user');
  // Map<String, UserModel> _user = {};
  List<UserModel> _user;
  List<UserModel> user;

  set listStaff(List<UserModel> val) {
    _user = val;
    notifyListeners();
  }

  List<UserModel> get listUsers => _user;
  // Map<String, UserModel> get users {
  //   return {..._user};
  // }

  int get userCount {
    return _user.length;
  }

  Future<void> create(UserModel userModel) async {
    try {
      print("inside create ");
      print(userModel.name);
      await collectionReference.add({
        'name': userModel.name,
        'cust_id': userModel.custId,
        'phone_no': userModel.phoneNo,
        'address': userModel.address,
        'place': userModel.place,
        'balance': userModel.balance,
        'timestamp': FieldValue.serverTimestamp()
      });
      notifyListeners();
      final newUser = UserModel(
        id: userModel.id,
        name: userModel.name,
        custId: userModel.custId,
        phoneNo: userModel.phoneNo,
        address: userModel.address,
        place: userModel.place,
      );

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List userlist = [];
    try {
      querySnapshot = await collectionReference.orderBy('timestamp').get();
      print("inside user read provider");
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "name": doc['name'],
            "custId": doc["cust_id"],
            "phoneNo": doc["phone_no"],
            "address": doc["address"],
            "place": doc["place"],
            "balance":doc['balance'],
          };
          userlist.add(a);
        }

        print(userlist);

        return userlist;
      }
    } catch (e) {
      print(e);
    }
  }

  void removeItem(String productId) {
    _user.remove(productId);
    notifyListeners();
  }

  void clear() {
    _user = [];
    notifyListeners();
  }
}

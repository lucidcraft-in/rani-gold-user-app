import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class GoldrateModel {
  final String id;
  final double gram;
  final double pavan;
  final double down;
  final double up;

  GoldrateModel({
    @required this.id,
    @required this.gram,
    @required this.pavan,
    @required this.down,
    @required this.up,
  });
  GoldrateModel.fromData(Map<String, dynamic> data)
      : id = data['id'],
        gram = data['gram'],
        pavan = data['pavan'],
        down = data['down'],
        up = data['up'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gram': gram,
      'pavan': pavan,
      'down': down,
       'up': up,
    };
  }
}

class Goldrate with ChangeNotifier {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('goldrate');

  List<GoldrateModel> _goldRate;

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List goldaRateList = [];
    try {
      querySnapshot = await collectionReference.get();

      if (querySnapshot.docs.isNotEmpty) {
        print("inside read ");
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "gram": doc['gram'],
            "pavan": doc["pavan"],
            "down": doc["down"],
             "up": doc["up"],
          };
          goldaRateList.add(a);
        }

        return goldaRateList;
      }
    } catch (e) {
      print(e);
    }
  }
}

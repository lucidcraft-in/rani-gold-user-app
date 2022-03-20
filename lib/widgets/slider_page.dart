import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SliderPage extends StatefulWidget {
  const SliderPage({Key key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  Stream slides;
 
  Stream _queryDb() {
    
    slides = FirebaseFirestore.instance
        .collection('slide')
        .snapshots()
        .map((list) => 
              list.docs.map((doc) => doc.data()),
              
            );

   
  }



   @override
  void initState() {
    _queryDb();
    super.initState();
  }

  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder(
        stream: slides,
        builder: (context, AsyncSnapshot snap) {
          List slideList = snap.data.toList();
          if (snap.hasError) {
            return Text(snap.error);
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return PageView.builder(
            
        controller: controller,
              itemCount: slideList.length,
              itemBuilder: (context, int index) {
                return _buildStoryPage(slideList[index]);
              });
        },
      ),
    );
  }

   

  // _buildStoryPage(Map data) {
  //   return ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Image.network(
  //                        data['photo'],
  //                      fit: BoxFit.cover,
  //                     ));
  // }

  _buildStoryPage(Map data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            data['photo'],
          ),
        ),
      ),
      // child: Center(
      //   child: Text(data['name']),
      // ),
    );
  }
}

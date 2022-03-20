import 'package:flutter/material.dart';

import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapScreen extends StatefulWidget {
  static const routeName = '/googlemap-screen';

  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(11.24974039853942, 75.78360224498293);  
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          // appBar: AppBar(
          //   title: Text('Maps Sample App'),
          //   backgroundColor: Colors.green[700],
          // ),
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              
              MapUtils.openMap(11.24974039853942, 75.78360224498293);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.navigation),
            
          ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
           
          ),
    );
  }
}

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

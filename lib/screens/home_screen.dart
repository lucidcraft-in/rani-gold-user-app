import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './login_screen.dart';
import '../widgets/home_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/local_push_notification.dart';
import '../screens/transaction_screen.dart';
import '../widgets/home_view.dart';
import '../screens/googlemap_screen.dart';
import '../screens/gold_rate_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _checkValue;
AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String appBarName = "RANI Jewellery";
  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() {
        appBarName = "RANI Jewellery";
      });
    }
    if (index == 1) {
      setState(() {
        appBarName = "Maps";
      });
    }

    if (index != 3) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }


  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });

    requestPermission();
    loadFCM();
    listenFCM();
    // getToken();

   
  }

    void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) => print(token));
  
  }

void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print('user declained or has not accepted permission');
    }
  }

  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _checkValue = prefs.containsKey('user');
  }

  Widget pageCaller(int index) {
    switch (index) {
      case 0:
        {
          return HomeView();
        }
      case 1:
        {
          return GoogleMapScreen();
        }

      case 2:
        {
          return GoldRateScreen();
        }
    }
  }

  

  redirectLoginPage() {
    print('_checkValue');
    print(_checkValue);
    if (_checkValue == true) {
      Navigator.of(context).pushNamed(TransactionScreen.routeName);
    } else {
      Navigator.of(context).pushNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            automaticallyImplyLeading:false,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.login,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    // do something
                  },
                )
              ], // centerTitle: true,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: 
              Image.asset(
                'assets/images/appbar.png',
                fit: BoxFit.cover
                // height: 28,
              ),
              // centerTitle: true,
              ),
        ),
        body: pageCaller(_selectedIndex),
        floatingActionButton: _selectedIndex != 1
            ? SpeedDial(
                icon: Icons.contact_page,
                buttonSize: 50,
                backgroundColor: Theme.of(context).accentColor,
                children: [
                    SpeedDialChild(
                      child: const FaIcon(
                        FontAwesomeIcons.phone,
                        color: Colors.white,
                        size: 15,
                      ),
                      // label: 'Call',
                      backgroundColor: Color(0xFF3DDC84),
                      onTap: () async {
                        await launch("tel://9496809664");
                      },
                    ),
                    SpeedDialChild(
                      child: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 26,
                      ),
                      // label: 'Whatsapp',
                      backgroundColor: Color(0xFF25D366),
                      onTap: () async {
                        await launch("https://wa.me/+919496809664?text=Hello Rani Jewellery");
                      },
                    ),
                  ])
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          
          //bottom navigation bar on scaffold
          color: Theme.of(context).accentColor,
          shape: CircularNotchedRectangle(), //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: Row(
            
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: FaIcon(FontAwesomeIcons.home,
                    size: 23,
                    color: _selectedIndex == 0
                        ? Theme.of(context).primaryColor
                        : Colors.black54),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.mapMarkerAlt,
                    size: 26,
                    color: _selectedIndex == 1
                        ? Theme.of(context).primaryColor
                        : Colors.black54),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              SizedBox(
                width: 25,
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.userCircle,
                    size: 25,
                    color: _selectedIndex == 2
                        ? Theme.of(context).primaryColor
                        : Colors.black54),
                onPressed: () {
                  _onItemTapped(3);
                  redirectLoginPage();
                  // Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
              ),
              //  SizedBox(width: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

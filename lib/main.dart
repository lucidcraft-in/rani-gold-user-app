import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import './providers/goldrate.dart';
import './providers/transaction.dart';
import './providers/user.dart';
import './service/local_push_notification.dart';
import './screens/home_screen.dart';
import './screens/transaction_screen.dart';
import './screens/googlemap_screen.dart';
import './screens/login_screen.dart';
import './screens/gold_rate_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   LocalNotificationService.initialize();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());

   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: buildMaterialColor(Color(0xFF612e3e)), // status bar color
  ));
}
class MyApp extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
          ChangeNotifierProvider(
          create: (_) => User(),
        ),
        ChangeNotifierProvider(
          create: (_) => Transaction(),
        ),
        ChangeNotifierProvider(
          create: (_) => Goldrate(),
        ),
        
      ],
      child: MaterialApp(
          title: 'Rani Jewellery',
          theme: ThemeData(
            primarySwatch:buildMaterialColor(Color(0xFF612e3e)),
            accentColor: Color(0xFFedbdc9),
            fontFamily: 'Lato',
            
          ),
  
          // home: Splash2(),
          home: AnimatedSplashScreen(
            splash:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
             Text(" Rani ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40),),
             Text("Jewellery",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
          
            ],),
            nextScreen: HomeScreen(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Color(0xFFebbbc7),
            duration: 2000,
            //  Container(
            //   height: 400,
            //   width: 400,
            //   color: Color(0xFF612e3e),
            // ),
          ),
          routes: {
            TransactionScreen.routeName: (ctx) => TransactionScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            GoogleMapScreen.routeName: (ctx) => GoogleMapScreen(),
            GoldRateScreen.routeName: (ctx) => GoldRateScreen(),
          }),
    );
  }
}


MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}


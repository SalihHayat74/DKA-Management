import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:management_of_dka_abgs/pages/Patient%20Data/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:management_of_dka_abgs/pages/Authentication%20Pages/register_screen.dart';
import 'package:management_of_dka_abgs/services/auth_services.dart';
import 'package:page_transition/page_transition.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: AuthService().firebaseAuth.authStateChanges(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return AnimatedSplashScreen(
              splash: "images/logoo.png",
              splashIconSize: 1000,
               nextScreen: HomePage(snapshot.data),
               splashTransition: SplashTransition.fadeTransition,
              duration: 2000,
              backgroundColor: Colors.white,
              curve: Curves.easeInCirc,
              pageTransitionType: PageTransitionType.fade,

             );
            //return HomePage(snapshot.data);
          }
          return RegisterScreen();
        },
      )
    )
  );
}






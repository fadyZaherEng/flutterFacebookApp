import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_firebase_app/layout/home_layout/home.dart';
import 'package:social_firebase_app/modules/login/login.dart';

class SplashScreen extends StatefulWidget {
String? name;

SplashScreen(this.name);

  @override
  State<SplashScreen> createState() => _SplashScreenState(name);
}

class _SplashScreenState extends State<SplashScreen> {
  String? name;

  _SplashScreenState(this.name);
  @override
  void initState() {
    Timer(const Duration(seconds: 3), (){
      if(name=='home') {
        Navigator.push(context,MaterialPageRoute(
          builder:(context)=>const HomeScreen()
      ) );
      }
      else
        {
          Navigator.push(context,MaterialPageRoute(
              builder:(context)=>LogInScreen()
          ) );
        }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
            child:CircleAvatar(
              radius: 62,
              backgroundImage: const AssetImage('assets/images/facebook.png'),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
        ),
      ),
    );
  }
}

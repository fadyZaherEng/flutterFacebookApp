import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme()=>ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.indigo,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(
        color: Colors.indigo,
      ),
      actionsIconTheme: IconThemeData(
        color: Colors.indigo,
      ),
    ),
    bottomNavigationBarTheme:  const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.indigo,
      elevation: 0.0,
    ),
    floatingActionButtonTheme:  FloatingActionButtonThemeData(
        backgroundColor: HexColor('180040')
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
        color: Colors.black,
      ),
      caption: TextStyle(
        color: Colors.black,
      ),
      subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.black,
      ),
    ),
    cardTheme: const CardTheme(
    color:Colors.white,
  ),
    hintColor: Colors.black,
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
);
ThemeData darkTheme()=>ThemeData(
  scaffoldBackgroundColor: HexColor('000028'),
  appBarTheme:  AppBarTheme(
    backgroundColor: HexColor('00028'),
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('000028'),
      statusBarIconBrightness: Brightness.light,
    ),
    iconTheme: const IconThemeData(
      color: Colors.blueAccent,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.blueAccent,
    ),
  ),
  bottomNavigationBarTheme:  BottomNavigationBarThemeData(
    elevation: 0.0,
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.blueAccent,
    backgroundColor:HexColor('000028'),
    unselectedItemColor: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.white,
      ),
    subtitle1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
    ),
    caption: TextStyle(
      color: Colors.white,
    ),
  ),
  cardTheme: CardTheme(
    color:HexColor('180040') ,
  ),
  hintColor: Colors.white,
  brightness: Brightness.dark,
  primaryColor:  Colors.white,
  drawerTheme: DrawerThemeData(
    backgroundColor: HexColor('000028'),
  ),
);

//Theme.of(context).textTheme.bodyText1
//https://image.freepik.com/free-vector/dating-application-concept-illustrated_52683-24296.jpg
//https://image.freepik.com/free-photo/young-couple-standing-back-back-using-cellphone_23-2147841115.jpg
//https://image.freepik.com/free-vector/people-background-design_23-2147676916.jpg
//https://image.freepik.com/free-photo/young-couple-sitting-back-back-using-whatsapp-smartphone_23-2147849494.jpg
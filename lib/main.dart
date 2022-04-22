// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:market_09/pages/login_page.dart';
import 'package:market_09/pages/product/products_page.dart';
import 'package:market_09/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          accentColor: Color(0xFFFF5722),
          primaryColorDark: Color(0xFF512DA8),
          primaryColor: Color(0xFF673AB7),
          textTheme: TextTheme(
              headline1: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
              headline2: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
              headline3: TextStyle(fontSize: 17.0),
              headline6: TextStyle(fontSize: 15.0),
              bodyText1: TextStyle(fontSize: 14.0),
              bodyText2: TextStyle(
                  fontStyle: FontStyle.italic, color: Colors.grey[300])),
          brightness: Brightness.dark),
      title: 'Tienda en linea',
      initialRoute: LoginPage.ROUTE,
      routes: {
        LoginPage.ROUTE: (_) => LoginPage(),
        RegisterPage.ROUTE: (_) => RegisterPage(),
        ProductsPage.ROUTE: (_) => ProductsPage(),
      },
    );
  }
}

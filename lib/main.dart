// ignore_for_file: prefer_const_constructors, , use_key_in_widget_constructors, prefer_typing_uninitialized_variables, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:market_09/models/app_state.dart';
import 'package:market_09/pages/cart/index_page.dart';
import 'package:market_09/pages/product/detail_page.dart';
import 'package:market_09/redux/actions.dart';
import 'package:market_09/redux/reducers.dart';
import 'package:redux/redux.dart';
import 'package:market_09/pages/login_page.dart';
import 'package:market_09/pages/product/products_page.dart';
import 'package:market_09/pages/register_page.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final store;
  const MyApp({this.store});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(
            // ignore: deprecated_member_use
            accentColor: Color(0xFFFF5722),
            primaryColorDark: Color(0xFF512DA8),
            primaryColor: Color(0xFF673AB7),
            textTheme: TextTheme(
                headline1:
                    TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold),
                headline2:
                    TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
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
          ProductsPage.ROUTE: (_) => ProductsPage(onInit: () {
                store.dispatch(getUserAction);
                store.dispatch(getProductAction);
              }),
          DetailPage.ROUTE: (_) => DetailPage(),
          IndexPage.ROUTE: (_) => IndexPage(onInit: () {
                //store.dispatch(getProductsCartAction);
              }),
        },
      ),
    );
  }
}

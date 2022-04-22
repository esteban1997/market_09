// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, avoid_unnecessary_containers, constant_identifier_names

import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  static const String ROUTE = "/products";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: Container(child: Text("Products")),
    );
  }
}

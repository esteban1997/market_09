// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:market_09/models/product.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final dynamic user;
  final List<Product> products;
  final List<Product> productCarts;

  AppState(
      {required this.user, required this.products, required this.productCarts});

  factory AppState.initial() {
    return AppState(user: null, products: [], productCarts: []);
  }

  List<Product> favorites() =>
      products.where((element) => element.favorite).toList();

  /*List<Product> carts() =>
      products.where((element) => element.cartCount >= 1).toList();*/

  Product findOne(Product product) {
    final int index = products.indexWhere((prod) => prod.id == product.id);
    return products[index];
  }
}

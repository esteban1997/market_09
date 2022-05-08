// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, constant_identifier_names, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:market_09/models/app_state.dart';
import 'package:market_09/models/product.dart';
import 'package:market_09/widgets/cart_item.dart';

class IndexPage extends StatefulWidget {
  static const ROUTE = "/cart";
  final Function()? onInit;

  const IndexPage({this.onInit});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit!();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) => Scaffold(
          appBar: AppBar(
            title: Text("listado carrito"),
            bottom: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.shopping_cart),
                  ),
                  Tab(
                    icon: Icon(Icons.credit_card),
                  ),
                ]),
          ),
          body: TabBarView(children: [_carTab(state), _orderTab(state)]),
        ),
      ),
    );
  }

  Widget _carTab(AppState state) {
    List<Product> productsCart = state.productCarts;

    return ListView.builder(
        itemCount: productsCart.length,
        itemBuilder: (_, int index) => CartItem(
              product: productsCart[index],
            ));
  }

  Widget _orderTab(state) {
    return Container(
      child: Text("Ordenes"),
    );
  }
}

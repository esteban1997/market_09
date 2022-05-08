// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, avoid_unnecessary_containers, constant_identifier_names, avoid_print, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:market_09/models/app_state.dart';
import 'package:market_09/models/product.dart';
import 'package:market_09/pages/cart/index_page.dart';
import 'package:market_09/pages/login_page.dart';
import 'package:market_09/pages/product/detail_page.dart';
import 'package:market_09/redux/actions.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsPage extends StatefulWidget {
  static const String ROUTE = "/products";
  final Function()? onInit;

  const ProductsPage({this.onInit});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool _showOnlyFavorite = false;

  @override
  void initState() {
    if (widget.onInit != null) {
      widget.onInit!();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Size size = MediaQuery.of(context).size;
    int countItem = 2;
    double space = size.width;
    if (orientation == Orientation.landscape) {
      countItem = 3;
    }

    if (space > 800) {}

    return StoreConnector<AppState, AppState>(converter: (store) {
      if (store.state.user != null) {
        store.dispatch(getProductsCartAction);
        store.dispatch(getProductsFavoriteAction);
      }
      return store.state;
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.store),
            onPressed: () {
              Navigator.pushNamed(context, IndexPage.ROUTE);
            },
          ),
          centerTitle: true,
          title:
              state.user == null ? Text("Products") : Text(state.user.username),
          actions: [
            PopupMenuButton(
                onSelected: (FilterOptions selected) {
                  setState(() {
                    if (selected == FilterOptions.Favorite) {
                      _showOnlyFavorite = true;
                    } else {
                      _showOnlyFavorite = false;
                    }
                  });
                },
                itemBuilder: (_) => [
                      PopupMenuItem(
                        child: Text("Favoritos"),
                        value: FilterOptions.Favorite,
                      ),
                      PopupMenuItem(
                        child: Text("All"),
                        value: FilterOptions.All,
                      ),
                    ]),
            state.user == null
                ? IconButton(
                    icon: Icon(Icons.login),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginPage.ROUTE);
                    },
                  )
                : StoreConnector<AppState, VoidCallback>(
                    converter: (store) =>
                        () => store.dispatch(logoutUserAction),
                    builder: (_, callback) {
                      return IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () {
                          callback();
                        },
                      );
                    },
                  )
          ],
        ),
        body: Container(
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                builder: (_, state) {
                  List<Product> products =
                      _showOnlyFavorite ? state.favorites() : state.products;

                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: countItem,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8),
                    itemBuilder: (_, item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, DetailPage.ROUTE,
                              arguments: products[item]);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GridTile(
                              footer: Container(
                                  color: Colors.black87,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[item].name,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "${products[item].price.toString()} \$",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w100,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  )),
                              header: GridTileBar(
                                title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                          products[item].cartCount >= 1
                                              ? Icons.shopping_cart
                                              : Icons.shopping_cart_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                      Icon(
                                          products[item].favorite
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ]),
                              ),
                              child: Image.network(
                                products[item].image,
                                fit: BoxFit.cover,
                              )),
                        ),
                      );
                      //return Text(state.products[item].name);
                    },
                  );
                })),
      );
    });
  }
}

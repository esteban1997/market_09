// ignore_for_file: prefer_function_declarations_over_variables, avoid_print, avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:market_09/models/app_state.dart';
import 'package:market_09/models/product.dart';
import 'package:market_09/models/user.dart';

import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;

import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

//middleware
ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();

  final Map<String, dynamic>? userMap = prefs.getString('email') == null
      ? null
      : ({
          'jwt': prefs.getString('jwt'),
          'email': prefs.getString('email'),
          'username': prefs.getString('username'),
          'id': prefs.getInt('id'),
          'cart_id': prefs.getInt('cart_id'),
          'favorite_id': prefs.getInt('favorite_id'),
        });

  final user = userMap == null ? null : User.fromJson(userMap);

  store.dispatch(GetUserAction(user));
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove('email');
  await prefs.remove('jwt');
  await prefs.remove('username');
  await prefs.remove('id');
  await prefs.remove('cart_id');
  await prefs.remove('favorite_id');

  store.dispatch(LogoutUserAction(null));
};

ThunkAction<AppState> getProductAction = (Store<AppState> store) async {
  final res = await http
      .get(Uri.parse('http://10.0.2.2:1337/api/products?populate=image'));

  final List<dynamic> resData = json.decode(res.body)['data'];

  final List<Product> products = [];

  resData.forEach((productMap) {
    final Product p = Product.fromJson(productMap);
    products.add(p);
  });

  store.dispatch(GetProductAction(products));
};

ThunkAction<AppState> updateProductAction(Product product) {
  return (Store<AppState> store) async {
    store.dispatch(UpdateProductAction(product));
  };
}

ThunkAction<AppState> toggleCartProductAction(Product cartProduct, int count) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.productCarts;
    final User user = store.state.user;

    final int index =
        cartProducts.indexWhere((element) => cartProduct.id == element.id);
    if (index > -1) {
      cartProduct.cartCount = 0;
      cartProducts.removeAt(index);
    } else {
      cartProduct.cartCount = count;
      cartProducts.add(cartProduct);
    }
    final List<Map> cartProductsIds = cartProducts
        .map((e) => {"product_id": e.id, "count": e.cartCount})
        .toList();

    var header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.jwt}"
    };

    var bodyCart = jsonEncode({
      'data': {'products': json.encode(cartProductsIds)}
    });

    final res = await http.put(
      Uri.parse('http://10.0.2.2:1337/api/carts/${user.cartId}'),
      headers: header,
      body: bodyCart,
    );

    store.dispatch(ToggleCartProductAction(cartProducts));
  };
}

ThunkAction<AppState> toggleFavoriteProductAction(Product productFavorite) {
  return (Store<AppState> store) async {
    final List<Product> products = store.state.products;
    final User user = store.state.user;

    final int index =
        products.indexWhere((element) => productFavorite.id == element.id);

    if (index > -1) {
      products[index].favorite = !products[index].favorite;
    }

    final List<Product> productsFavorite =
        products.where((element) => element.favorite).toList();

    final List<Map> productsFavoritesId =
        productsFavorite.map((e) => {"product_id": e.id}).toList();

    var header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.jwt}"
    };

    var bodyFavorites = jsonEncode({
      'data': {'products': json.encode(productsFavoritesId)}
    });

    final res = await http.put(
      Uri.parse('http://10.0.2.2:1337/api/favorites/${user.favoriteId}'),
      headers: header,
      body: bodyFavorites,
    );

    store.dispatch(ToggleFavoriteProductAction(products));
  };
}

ThunkAction<AppState> changeCartProductAction(Product cartProduct, int count) {
  return (Store<AppState> store) async {
    final List<Product> cartProducts = store.state.productCarts;
    final User user = store.state.user;

    final int index =
        cartProducts.indexWhere((element) => cartProduct.id == element.id);

    if (index > -1) {
      cartProduct.cartCount = count;
    } else {}

    final List<Map> cartProductsIds = cartProducts
        .map((e) => {"product_id": e.id, "count": e.cartCount})
        .toList();

    var header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${user.jwt}"
    };

    var body2 = jsonEncode({
      'data': {'products': json.encode(cartProductsIds)}
    });

    await http.put(
      Uri.parse('http://10.0.2.2:1337/api/carts/${user.cartId}'),
      headers: header,
      body: body2,
    );

    store.dispatch(ChangeCartProductAction(cartProducts));
  };
}

ThunkAction<AppState> getProductsCartAction = (Store<AppState> store) async {
  final User user = store.state.user;

  var header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${user.jwt}"
  };
  final res = await http.get(
      Uri.parse('http://10.0.2.2:1337/api/carts/${user.cartId}'),
      headers: header);

  if (res.statusCode == 200) {
    final resData = json.decode(res.body);

    final resDataProducts =
        json.decode(resData['data']['attributes']['products']);

    return store.dispatch(GetProductsCartAction(
        _setProductsIdToProducts(store, resDataProducts)));
  } else {
    return store.dispatch(GetProductsCartAction([]));
  }
};

ThunkAction<AppState> getProductsFavoriteAction =
    (Store<AppState> store) async {
  final User user = store.state.user;

  var header = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${user.jwt}"
  };
  final res = await http.get(
      Uri.parse('http://10.0.2.2:1337/api/favorites/${user.favoriteId}'),
      headers: header);

  if (res.statusCode == 200) {
    final resData = json.decode(res.body);

    final resDataProducts =
        json.decode(resData['data']['attributes']['products']);

    return store.dispatch(GetProductFavoriteAction(
        _setProductsIdToProductsFavorites(store, resDataProducts)));
  } else {
    return store.dispatch(GetProductFavoriteAction([]));
  }
};

List<Product> _setProductsIdToProducts(
    Store<AppState> store, List<dynamic> productsMap) {
  List<Product> productsCart = [];

  productsMap.forEach((pMap) {
    final index =
        store.state.products.indexWhere((p) => p.id == pMap['product_id']);

    if (index > -1) {
      store.state.products[index].cartCount = pMap['count'];
      productsCart.add(store.state.products[index]);
    }
  });

  return productsCart;
}

List<Product> _setProductsIdToProductsFavorites(
    Store<AppState> store, List<dynamic> productsMap) {
  List<Product> productsFavorite = store.state.products;

  productsMap.forEach((pMap) {
    final index =
        store.state.products.indexWhere((p) => p.id == pMap['product_id']);

    if (index > -1) {
      store.state.products[index].favorite = true;
    } else {}
  });

  return productsFavorite;
}

class GetProductsCartAction {
  final List<Product> _productsCart;

  GetProductsCartAction(this._productsCart);

  dynamic get productsCart => _productsCart;
}

class GetProductFavoriteAction {
  final List<Product> _productsFavorite;

  GetProductFavoriteAction(this._productsFavorite);

  dynamic get productsFavorite => _productsFavorite;
}

//acciones
class GetUserAction {
  final dynamic _user;

  dynamic get user => _user;

  GetUserAction(this._user);
}

class LogoutUserAction {
  final dynamic _user;

  dynamic get user => _user;

  LogoutUserAction(this._user);
}

class GetProductAction {
  final List<Product> _products;

  GetProductAction(this._products);

  dynamic get products => _products;
}

class UpdateProductAction {
  late final _product;

  UpdateProductAction(this._product);

  dynamic get product => _product;
}

class ToggleCartProductAction {
  late final _cartProduct;

  ToggleCartProductAction(this._cartProduct);

  dynamic get cartProduct => _cartProduct;
}

class ChangeCartProductAction {
  late final _cartProduct;

  ChangeCartProductAction(this._cartProduct);

  dynamic get cartProduct => _cartProduct;
}

class ToggleFavoriteProductAction {
  late final _favoriteProduct;

  ToggleFavoriteProductAction(this._favoriteProduct);

  dynamic get favoriteProduct => _favoriteProduct;
}

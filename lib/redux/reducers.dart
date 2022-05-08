import 'package:market_09/models/app_state.dart';
import 'package:market_09/redux/actions.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      user: userReducer(state.user, action),
      products: productReducer(state.products, action),
      productCarts: productCartReducer(state.productCarts, action));
}

userReducer(user, action) {
  if (action is GetUserAction) {
    return action.user;
  }
  if (action is LogoutUserAction) {
    return action.user;
  }

  return user;
}

productReducer(List products, action) {
  if (action is GetProductAction) {
    return action.products ?? products;
  } else if (action is UpdateProductAction) {
    final int index =
        products.indexWhere((prod) => prod.id == action.product.id);
    products[index] = action.product;

    return products;
  } else if (action is ToggleFavoriteProductAction) {
    return action.favoriteProduct;
  } else if (action is GetProductFavoriteAction) {
    return action.productsFavorite;
  } else {
    return products;
  }
}

productCartReducer(List productCarts, action) {
  if (action is ToggleCartProductAction) {
    return action.cartProduct;
  } else if (action is GetProductsCartAction) {
    return action.productsCart;
  } else if (action is ChangeCartProductAction) {
    return action.cartProduct;
  } else {
    return productCarts;
  }
}

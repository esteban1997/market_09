// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_brace_in_string_interps, avoid_print, sized_box_for_whitespace, prefer_final_fields, prefer_const_constructors_in_immutables, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:market_09/models/app_state.dart';
import 'package:market_09/models/product.dart';
import 'package:market_09/redux/actions.dart';

class CartItem extends StatefulWidget {
  final Product product;

  CartItem({required this.product});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  TextEditingController _quantity = TextEditingController(text: "1");
  late double _totalPrice;

  @override
  void initState() {
    _quantity.text = widget.product.cartCount.toString();
    _totalPrice = widget.product.price * widget.product.cartCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
        converter: (store) => () {
              //widget.product.cartCount = 0;
              store.dispatch(toggleCartProductAction(widget.product, 0));
            },
        builder: (_, callback) => Dismissible(
              direction: DismissDirection.startToEnd,
              key: ValueKey(widget.product.id),
              background: Container(
                padding: EdgeInsets.only(right: 20),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        '\$ ${widget.product.price}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  title: Text(widget.product.name),
                  subtitle: Text("Precio c/u \$${(widget.product.price)}"),
                  trailing: Wrap(children: [
                    Container(
                        width: 30,
                        height: 18,
                        child: StoreConnector<AppState, VoidCallback>(
                          converter: (store) => () {
                            int? cantidad = int.tryParse(_quantity.text);
                            store.dispatch(changeCartProductAction(
                                widget.product, cantidad!));
                          },
                          builder: (_, callback) => TextField(
                            style: Theme.of(context).textTheme.bodyText1,
                            keyboardType: TextInputType.number,
                            controller: _quantity,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            ],
                            onChanged: (String value) {
                              int n = 1;
                              try {
                                n = int.parse(value);
                                if (n <= 0) {
                                  n = 1;
                                  _quantity.text = n.toString();
                                }
                                callback();
                              } catch (e) {}

                              setState(() {
                                _totalPrice = widget.product.price * n;
                              });
                            },
                          ),
                        )),
                    Text(
                      " x \$${(widget.product.price)} = \$$_totalPrice",
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  ]),
                ),
              ),
              confirmDismiss: (_) {
                return showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("seguro deseas eliminar"),
                    content: Text("seguro deseas eliminar el elemento"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text("Si"),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) {
                callback();
              },
            ));
  }
}

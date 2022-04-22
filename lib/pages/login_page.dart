// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:market_09/pages/product/products_page.dart';
import 'package:market_09/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscurePawword = true;
  bool _isSubmitedText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        child: Form(
          //estado del mismo para referenciarlo
          key: _formKey,
          child: Container(
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _emailTF(),
                  _passwordTF(),
                  _actionsTF(context)
                ],
              )),
        ),
      ),
    );
  }

  Column _actionsTF(BuildContext context) {
    return Column(
      children: [
        _isSubmitedText
            ? CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Formulario valido");
                    _loginUser();
                    _redirectUser();
                  } else {
                    print("errores");
                  }
                },
                child: Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                )),
        TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, RegisterPage.ROUTE);
            },
            child: Text("Registrarse"))
      ],
    );
  }

  Padding _emailTF() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: _emailController,
        validator: (value) => !value!.contains('@') ? 'Email invalido' : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Coloque email",
            icon: Icon(Icons.email)),
      ),
    );
  }

  TextFormField _passwordTF() {
    return TextFormField(
      obscureText: _obscurePawword,
      controller: _passwordController,
      validator: (value) => value!.length < 5 ? 'Contraseña invalido' : null,
      decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              _obscurePawword = !_obscurePawword;
              setState(() {});
            },
            child:
                Icon(_obscurePawword ? Icons.visibility : Icons.visibility_off),
          ),
          border: OutlineInputBorder(),
          labelText: "Password",
          hintText: "Ingrese password",
          icon: Icon(Icons.lock)),
    );
  }

  void _loginUser() async {
    _isSubmitedText = true;
    setState(() {});
    print(_emailController.text);
    print(_passwordController.text);
    final res = await http
        .post(Uri.parse('http://10.0.2.2:1337/api/auth/local'), body: {
      "identifier": _emailController.text,
      "password": _passwordController.text,
    });

    _isSubmitedText = false;
    setState(() {});

    final responseData = json.decode(res.body);

    if (res.statusCode == 200) {
      print("correcto");
      print(responseData);
      _succesResponse();
      _storeUserData(responseData);
    } else {
      print("incorrecto");
      print(responseData);
      _errorResponse(responseData['error']['message']);
    }

    print(responseData);
  }

  void _succesResponse() {
    final _snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Usuario ${_emailController.text} correcto",
          style: TextStyle(color: Colors.white),
        ));

    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  void _errorResponse(var messageError) {
    final _snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          messageError,
          style: TextStyle(color: Colors.white),
        ));

    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  void _storeUserData(Map<String, dynamic> responseData) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("jwt", responseData['jwt']);
    prefs.setInt("id", responseData['user']['id']);
    prefs.setString("username", responseData['user']['username']);
    prefs.setString("email", responseData['user']['email']);
  }

  void _redirectUser() {
    Future.delayed(Duration(milliseconds: 2000), () {
      Navigator.pushReplacementNamed(context, ProductsPage.ROUTE);
    });
  }
}

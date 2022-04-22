// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market_09/pages/login_page.dart';

import 'package:http/http.dart' as http;
import 'package:market_09/pages/product/products_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  static const String ROUTE = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _userController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePawword = true;
  bool _obscureConfirmPawword = true;
  bool _isSubmitedText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("Registrarse")),
      body: SingleChildScrollView(
        child: Form(
          //estado del mismo para referenciarlo
          key: _formKey,
          child: Container(
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    "Registrarse",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _emailTF(),
                  SizedBox(
                    height: 5,
                  ),
                  _usernameTF(),
                  SizedBox(
                    height: 5,
                  ),
                  _passwordTF(),
                  SizedBox(
                    height: 15,
                  ),
                  _confirmPasswordTF(),
                  SizedBox(
                    height: 5,
                  ),
                  _actionsTF(context)
                ],
              )),
        ),
      ),
    );
  }

  Widget _emailTF() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (!value!.contains('@')) {
            return 'Email invalido';
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Coloque email",
            icon: Icon(Icons.email)),
      ),
    );
  }

  Widget _usernameTF() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: _userController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Ingrese un usuario";
          }
          return null;
        },
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Usuario",
            hintText: "Ingrese su usuario",
            icon: Icon(Icons.account_circle)),
      ),
    );
  }

  Widget _confirmPasswordTF() {
    return TextFormField(
      obscureText: _obscureConfirmPawword,
      controller: _confirmPasswordController,
      validator: (value) {
        if (_passwordController.text != value) {
          return 'Las contraseñas no coinciden';
        }
        if (value!.isEmpty) {
          return 'Confirme la contraseña';
        }

        return null;
      },
      decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              _obscureConfirmPawword = !_obscureConfirmPawword;
              setState(() {});
            },
            child: Icon(_obscureConfirmPawword
                ? Icons.visibility
                : Icons.visibility_off),
          ),
          border: OutlineInputBorder(),
          labelText: "Confirmar Password",
          hintText: "Repita el password",
          icon: Icon(Icons.lock)),
    );
  }

  Widget _passwordTF() {
    return TextFormField(
      obscureText: _obscurePawword,
      controller: _passwordController,
      validator: (value) => value!.length < 7 ? 'Contraseña invalido' : null,
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

  Widget _actionsTF(BuildContext context) {
    return Builder(
      builder: (context) => Column(
        children: [
          _isSubmitedText
              ? CircularProgressIndicator()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Formulario valido");
                      _registerUser();
                    } else {
                      print("errores");
                    }
                  },
                  child: Text(
                    "Registrarse",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  )),
          TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.ROUTE);
              },
              child: Text("ir al login"))
        ],
      ),
    );
  }

  void _registerUser() async {
    _isSubmitedText = true;
    setState(() {});

    final res = await http
        .post(Uri.parse('http://10.0.2.2:1337/api/auth/local/register'), body: {
      "username": _userController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
    });

    final responseData = json.decode(res.body);
    _isSubmitedText = false;

    setState(() {});
    if (res.statusCode == 200) {
      print("respuesta 200");
      print(res.body);
      _succesResponse();
      _storeUserData(responseData);
      _redirectUser();
    } else {
      print("se presento algun error");
      print(res.body);
      _errorResponse(responseData['error']['message']);
    }
  }

  void _succesResponse() {
    final _snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Usuario ${_userController.text} creado \\°n°\\ /°n°/ \\°n°\\ /°n°/",
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

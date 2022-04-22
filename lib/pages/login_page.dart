// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:market_09/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  static const String ROUTE = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _obscurePawword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) =>
                          !value!.contains('@') ? 'Email invalido' : null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          hintText: "Coloque email",
                          icon: Icon(Icons.email)),
                    ),
                  ),
                  TextFormField(
                    obscureText: _obscurePawword,
                    controller: _passwordController,
                    validator: (value) =>
                        value!.length < 5 ? 'Contraseña invalido' : null,
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _obscurePawword = !_obscurePawword;
                            setState(() {});
                          },
                          child: Icon(_obscurePawword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        hintText: "Ingrese password",
                        icon: Icon(Icons.lock)),
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print("Formulario valido");
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
                            Navigator.pushReplacementNamed(
                                context, RegisterPage.ROUTE);
                          },
                          child: Text("Registrarse"))
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

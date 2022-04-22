// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, avoid_print, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:market_09/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  static const String ROUTE = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _userController = TextEditingController();
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePawword = true;
  bool _obscureConfirmPawword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Padding(
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
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
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
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
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
                  ),
                  SizedBox(
                    height: 5,
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
                            "Registrarse",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginPage.ROUTE);
                          },
                          child: Text("ir al login"))
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}

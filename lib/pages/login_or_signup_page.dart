import 'package:flutter/material.dart';
import 'package:lista_contatos/pages/login_page.dart';
import 'package:lista_contatos/pages/signup_page.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key});

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  bool mostrarPaginaLogin = true;

  void trocarTelas() {
    setState(() {
      mostrarPaginaLogin = !mostrarPaginaLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mostrarPaginaLogin) {
      return LoginPage(
        onTap: trocarTelas,
      );
    } else {
      return SignupPage(
        onTap: trocarTelas,
      );
    }
  }
}

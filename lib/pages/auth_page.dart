import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_contatos/pages/home_page.dart';
import 'package:lista_contatos/pages/login_or_signup_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //usuário está logado
          if (snapshot.hasData) {
            return HomePage();
          } else {
            //usuário não está logado
            return LoginOrSignupPage();
          }
        },
      ),
    );
  }
}

class AuthService {
  Future<void> enviarEmailRecuperacaoSenha(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_contatos/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  void logarUsuario() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (mounted) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: senhaController.text,
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == "invalid-credential") {
          mostrarMsgErro("Login incorreto");
        } else if (e.code == "invalid-email") {
          mostrarMsgErro("Email inválido");
        }
      }
    }
  }

  void mostrarMsgErro(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          backgroundColor: Colors.deepPurple,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
        titleTextStyle: TextStyle(
            color: Colors.purple.shade300,
            fontSize: 21,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Faça o seu login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                    icon: Icons.mail),
                const SizedBox(
                  height: 30,
                ),
                MyTextfield(
                    controller: senhaController,
                    hintText: "Senha",
                    obscureText: true,
                    icon: Icons.lock),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: logarUsuario,
                  child: Text("Login"),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não possui uma conta?",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Cadastre-se!",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

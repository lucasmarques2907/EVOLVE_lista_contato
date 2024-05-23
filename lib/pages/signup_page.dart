import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;

  SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

//começa aqui

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final repetirSenhaController = TextEditingController();

  void cadastrarUsuario() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (emailController.text.isEmpty ||
        senhaController.text.isEmpty ||
        repetirSenhaController.text.isEmpty) {
      Navigator.pop(context);
      mostrarMsgErro("Preencha todos os campos!");
      return;
    } else if (senhaController.text.length < 6 ||
        repetirSenhaController.text.length < 6) {
      Navigator.pop(context);
      mostrarMsgErro("Sua senha precisa ter pelo menos 6 caracteres!");
      return;
    } else if (senhaController.text != repetirSenhaController.text) {
      Navigator.pop(context);
      mostrarMsgErro("Suas senhas estão diferentes, confira novamente!");
      return;
    }

    try {
      print("1");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == "invalid-email") {
        mostrarMsgErro("Email inválido");
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
        title: Text("Cadastro"),
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
                  "Faça o seu cadastro",
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
                  icon: Icons.mail,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextfield(
                  controller: senhaController,
                  hintText: "Senha",
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyTextfield(
                  controller: repetirSenhaController,
                  hintText: "Repita a sua senha",
                  obscureText: true,
                  icon: Icons.lock,
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                  onPressed: cadastrarUsuario,
                  child: Text("Cadastrar"),
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
                      "Já possui uma conta?",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Faça login!",
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

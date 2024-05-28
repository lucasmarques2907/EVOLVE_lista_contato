import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

final _formKey = GlobalKey<FormState>();

class SignupPage extends StatefulWidget {
  final Function()? onTap;

  SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

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

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: senhaController.text,
    );

    Navigator.pop(context);
  }

  String? validarEmail(String email) {
    final bool emailValido = EmailValidator.validate(email);
    if (!emailValido) {
      return "Por favor, insira um email válido.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Animate(
        effects: [FadeEffect()],
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Faça o seu cadastro",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: emailController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.deepPurple,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "Email",
                          labelStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) => validarEmail(value.toString()),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        controller: senhaController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) => value!.length < 6
                            ? "Sua senha precisa ter no mínimo 6 caracteres"
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                        obscureText: true,
                        textAlignVertical: TextAlignVertical.center,
                        controller: repetirSenhaController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "Repita a sua senha",
                          labelStyle: TextStyle(color: Colors.grey[800]),
                        ),
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) => value != senhaController.text
                            ? "Suas senhas não são iguais, confira novamente"
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(25,),),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: Offset(0,3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cadastrarUsuario();
                          }
                        },
                        child: Text("Cadastrar"),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
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
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Já possui uma conta?",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Faça login!",
                            style: TextStyle(
                              color: Colors.deepPurple,
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
        ),
      ),
    );
  }
}

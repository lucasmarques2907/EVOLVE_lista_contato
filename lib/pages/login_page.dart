import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lista_contatos/pages/forgot_password_page.dart';

final _formKey = GlobalKey<FormState>();

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
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );

      // Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        mostrarMsgErro("Login incorreto",
            "Confira se seu email e sua senha estão corretos");
      }
      // Navigator.pop(context);
    }
  }

  void mostrarMsgErro(String tituloMensagem, String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 72,
                  color: Colors.deepPurple,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(tituloMensagem,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 5,
                ),
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? validarEmail(String email) {
    final bool emailValido = EmailValidator.validate(email);
    if (!emailValido) {
      return "Por favor, insira um email válido.";
    }
    return null;
  }

  bool visibilidadeSenha = true;

  @override
  void initState() {
    visibilidadeSenha = true;
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
                    const Text(
                      "Bem-vindo de volta",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
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
                              borderRadius: BorderRadius.circular(15)),
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
                        obscureText: visibilidadeSenha ? true : false,
                        textAlignVertical: TextAlignVertical.center,
                        controller: senhaController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          labelText: "Senha",
                          labelStyle: TextStyle(color: Colors.grey[800]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              visibilidadeSenha
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () {
                              setState(() {
                                visibilidadeSenha = !visibilidadeSenha;
                              });
                            },
                          ),
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
                    SizedBox(
                      height: 0,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage(),
                                    ));
                              },
                              child: Text("Esqueci minha senha")),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            25,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.3),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            logarUsuario();
                          }
                        },
                        child: Text("Login"),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                          ),
                          textStyle: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
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
                          "Não possui uma conta?",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Cadastre-se!",
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

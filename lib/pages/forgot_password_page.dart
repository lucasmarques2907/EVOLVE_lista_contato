import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lista_contatos/pages/auth_page.dart';

final _formKey = GlobalKey<FormState>();

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();

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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepPurple, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body:
      Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Digite seu email para receber as instruções de troca de senha", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _email,
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
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState!.validate()){
                          await AuthService().enviarEmailRecuperacaoSenha(_email.text);
                          Fluttertoast.showToast(
                            msg: "Email enviado",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.deepPurple,
                            textColor: Colors.white,
                            fontSize: 16,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Enviar"),
                      style: ElevatedButton.styleFrom(
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
                    )
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

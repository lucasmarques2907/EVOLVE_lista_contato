import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_contatos/components/my_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddContact extends StatefulWidget {
  final String? usuarioAtual;

  const AddContact({super.key, this.usuarioAtual});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final nomeController = TextEditingController();
  final celularController = TextEditingController();
  final cepController = TextEditingController();
  final estadoController = TextEditingController();
  final cidadeController = TextEditingController();
  final bairroController = TextEditingController();
  final ruaController = TextEditingController();
  final complementoController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    super.dispose();
  }

  final usuarioAtual = FirebaseAuth.instance.currentUser;

  Future<void> salvarContato() async {
    final docContato = FirebaseFirestore.instance.collection("Contato").doc();

    String? id = docContato.id;

    await docContato.set({'id': id, "usuarioEmail": usuarioAtual!.email!, "nome": nomeController.text, "celular": celularController.text, "cep": cepController.text, "uf": estadoController.text, "cidade": cidadeController.text, "bairro": bairroController.text, "rua": ruaController.text, "complemento": complementoController.text, "dataCriacao": Timestamp.now()});
    Navigator.pop(context);
  }

  String resultado = "";

  void buscaCep(String value) async{
    String cep = value;

    String url = "https://viacep.com.br/ws/$cep/json/";

    http.Response resposta;

    resposta = await http.get(Uri.parse(url));

    print("Resposta: " + resposta.body);

    print("StatusCode: "+ resposta.statusCode.toString());

    Map<String, dynamic> dadosCep = json.decode(resposta.body);

    estadoController.text = dadosCep["uf"];
    cidadeController.text = dadosCep["localidade"];
    bairroController.text = dadosCep["bairro"];
    ruaController.text = dadosCep["logradouro"];
    complementoController.text = dadosCep["complemento"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple.shade300),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        title: Text("Adicionar contato"),
        titleTextStyle: TextStyle(
            color: Colors.purple.shade300,
            fontSize: 21,
            fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    MyTextfield(
                      controller: nomeController,
                      hintText: "Nome",
                      obscureText: false,
                      icon: Icons.person,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MyTextfield(
                      controller: celularController,
                      hintText: "Celular/Telefone",
                      obscureText: false,
                      icon: Icons.phone,
                    ),
                    SizedBox(
                      height: 5,
                    ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: cepController,
            onChanged: (value) async {
              if (value.length == 8){
                buscaCep(value);
              }
            },
            obscureText: false,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.purple.shade500,
                ),
              ),
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              fillColor: Colors.grey.shade800,
              filled: true,
              hintText: "CEP",
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ),
                    SizedBox(
                      height: 5,
                    ),
                    MyTextfield(
                      controller: estadoController,
                      hintText: "Estado",
                      obscureText: false,
                      icon: Icons.location_on,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MyTextfield(
                      controller: cidadeController,
                      hintText: "Cidade",
                      obscureText: false,
                      icon: Icons.location_on,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MyTextfield(
                      controller: bairroController,
                      hintText: "Bairro",
                      obscureText: false,
                      icon: Icons.location_on,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MyTextfield(
                      controller: ruaController,
                      hintText: "Rua",
                      obscureText: false,
                      icon: Icons.location_on,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    MyTextfield(
                      controller: complementoController,
                      hintText: "Complemento",
                      obscureText: false,
                      icon: Icons.location_on,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 25),
              tileColor: Colors.black,
              title: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[500]),
                      child: Text(
                        "Cancelar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: salvarContato,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[500]),
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
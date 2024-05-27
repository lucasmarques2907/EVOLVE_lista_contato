import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_contatos/pages/add_contact.dart';
import 'package:lista_contatos/service/database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final _formKey = GlobalKey<FormState>();

class EditContact extends StatefulWidget {
  final String id;

  const EditContact({super.key, required this.id});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {

  final nomeController = TextEditingController();
  final celularController = TextEditingController();
  final cepController = TextEditingController();
  final estadoController = TextEditingController();
  final cidadeController = TextEditingController();
  final bairroController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final complementoController = TextEditingController();

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

  void atualizarContato() async {
    Map<String, dynamic> atualizarInfo={
      "nome": nomeController.text,
      "celular": celularController.text,
      "cep": cepController.text,
      "uf": estadoController.text,
      "cidade": cidadeController.text,
      "bairro": bairroController.text,
      "rua": ruaController.text,
      "numero": numeroController.text,
      "complemento": complementoController.text
    };
    await DatabaseMethods().atualizarContato(widget.id, atualizarInfo, context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("Editar contato"),
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                    FirebaseFirestore.instance.collection("Contato").where("id", isEqualTo: widget.id).snapshots(),
                    builder: (context, snapshots) {
                      return (snapshots.connectionState == ConnectionState.waiting)
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                            as Map<String, dynamic>;
                            if (data['id'].trim().isNotEmpty) {
                              buscaCep(data["cep"]);
                              nomeController.text = data["nome"];
                              celularController.text = data["celular"];
                              cepController.text = data["cep"];
                              numeroController.text = data["numero"];
                              complementoController.text = data["complemento"];
                              return Column(
                                children: [
                                  SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: nomeController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Nome",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Este campo não pode ficar vazio!"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: celularController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        errorMaxLines: 2,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Celular/Telefone",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().isEmpty
                                          ? "Este campo não pode ficar vazio!"
                                          : value!.length < 3
                                          ? "O númeo de celular/telefone precisa ter no mínimo 3 dígitos"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(8),
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: cepController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "CEP",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      onChanged: (value) async{
                                        if(value.length ==8 ){
                                          buscaCep(value);
                                        }
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Digite os 8 dígitos do CEP"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      inputFormatters:
                                      <TextInputFormatter>[
                                        UpperCaseTxt(),
                                        LengthLimitingTextInputFormatter(2),
                                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z]')),
                                      ],
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: estadoController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Estado",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onChanged: (value) {
                                        estadoController.value =
                                            TextEditingValue(
                                                text: value.toUpperCase(),
                                                selection: estadoController.selection);
                                      },
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Digite apenas a sigla do estado!"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: cidadeController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Cidade",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Este campo não pode ficar vazio!"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: bairroController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Bairro",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Este campo não pode ficar vazio!"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: ruaController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Rua",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Este campo não pode ficar vazio!"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: numeroController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Número",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => value.toString().trim().isEmpty
                                          ? "Este campo não pode ficar vazio!"
                                          : null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: TextFormField(
                                      textAlignVertical: TextAlignVertical.center,
                                      controller: complementoController,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.deepPurple),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                        ),
                                        fillColor: Colors.grey.shade800,
                                        filled: true,
                                        labelText: "Complemento",
                                        labelStyle: TextStyle(color: Colors.grey[500]),
                                      ),
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      validator: (value) => null,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              );
                            }
                            return Container();
                          });
                    },
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
                            backgroundColor: Colors.redAccent),
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
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            atualizarContato();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lista_contatos/components/my_textfield.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

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
                    MyTextfield(
                      controller: cepController,
                      hintText: "CEP",
                      obscureText: false,
                      icon: Icons.add_location,
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
                      onPressed: () {
                        print("salvar");
                      },
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

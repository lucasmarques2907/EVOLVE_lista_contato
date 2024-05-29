import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.deepPurple, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Informações do app",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Pacotes utilizados",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                buildDivider(),
                buildRowPacoteNome("cupertino_icons", "1.0.6"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("flutter_profile_picture", "2.0.0"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("fluttertoast", "8.2.5"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("provider", "6.1.2"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("firebase_core", "2.31.1"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("cloud_firestore", "4.17.4"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("firebase_auth", "4.19.6"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("http", "1.2.1"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("email_validator", "2.1.17"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("flutter_animate", "4.5.0"),
                SizedBox(
                  height: 5,
                ),
                buildRowPacoteNome("flutter_launcher_icons", "0.13.1"),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildRowPacoteNome(String nome, String versao) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nome,
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          versao,
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Divider buildDivider() {
    return Divider(
      color: Colors.deepPurple,
      indent: 20,
      endIndent: 20,
    );
  }
}

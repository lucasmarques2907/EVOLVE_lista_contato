import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lista_contatos/pages/add_contact.dart';
import 'package:lista_contatos/pages/contact_page.dart';
import 'package:lista_contatos/service/firestore.dart';
import '../models/contact_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usuarioAtual = FirebaseAuth.instance.currentUser;

  void deslogarUsuario() {
    FirebaseAuth.instance.signOut();
  }

  Stream? contatoStream;

  infoAoCarregar() async {
    contatoStream = await DatabaseMethods().getDetalhesContato();
  }

  @override
  void initState() {
    infoAoCarregar();
    super.initState();
  }

  StreamBuilder<dynamic> buildStreamBuilder() {
    return StreamBuilder(
      stream: contatoStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot contato =
                snapshot.data!.docs[index];
                return Material(
                  child: ListTile(
                    title: Text(
                      contato["Nome"],
                    ),
                    subtitle: Text(contato["Celular"]),
                  ),
                );
              });
        }
        return const Center(
          child: CircularProgressIndicator(),
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
        title: Text("Home"),
        titleTextStyle: TextStyle(
            color: Colors.purple.shade300,
            fontSize: 21,
            fontWeight: FontWeight.bold),
        actions: [
          IconButton(
              onPressed: deslogarUsuario,
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
                onChanged: (value) => setState(() {
                      print(value);
                    }),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade700,
                  hintText: "Pesquisar contato",
                  hintStyle:
                      TextStyle(fontSize: 17, color: Colors.grey.shade500),
                  suffixIcon: const Icon(
                    Icons.search,
                    size: 26,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: buildStreamBuilder(),
              ),
            ),
            SizedBox(
              height: 75,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddContact(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

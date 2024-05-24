import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lista_contatos/pages/add_contact.dart';
import 'package:lista_contatos/pages/contact_page.dart';

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

  String name = "";

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
      body: SafeArea(
        child: Column(
          children: [
            TextField(
                onChanged: (value) => setState(() {
                      name = value;
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Contato")
                      .where("usuarioEmail", isEqualTo: usuarioAtual!.email!)
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              if (name.trim().isEmpty) {
                                return ListTile(
                                  title: Text(
                                    data["nome"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    data["celular"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactPage(
                                          id: data["id"].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              if (data["nome"]
                                      .toString()
                                      .toLowerCase()
                                      .toString()
                                      .startsWith(name.toLowerCase()) ||
                                  data["nome"]
                                      .toString()
                                      .toLowerCase()
                                      .contains(name.toLowerCase())) {
                                return ListTile(
                                  title: Text(
                                    data["nome"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    data["celular"],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ContactPage(
                                          id: data["id"].toString(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              return Container();
                            });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

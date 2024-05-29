import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lista_contatos/pages/add_contact.dart';
import 'package:lista_contatos/pages/contact_page.dart';
import 'package:lista_contatos/pages/information_page.dart';
import 'package:lista_contatos/providers/search_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.white,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.0, 0.3],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        centerTitle: true,
        title: Text("Contatos"),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InformationPage(),
              ),
            );
          },
          icon: const Icon(
            Icons.info_outline_rounded,
            color: Colors.deepPurple,
          ),
        ),
        actions: [
          IconButton(
            onPressed: deslogarUsuario,
            icon: const Icon(
              Icons.logout,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
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
                onChanged: (value) {
                  context
                      .read<SearchProvider>()
                      .filtrarContatos(pesquisa: value);
                  print(context.read<SearchProvider>().nome);
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: "Pesquisar contato",
                  hintStyle:
                      TextStyle(fontSize: 17, color: Colors.grey.shade500),
                  suffixIcon: const Icon(
                    Icons.search,
                    size: 26,
                    color: Colors.deepPurple,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
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
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Contato")
                      .where("usuarioEmail", isEqualTo: usuarioAtual!.email!)
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? Container()
                        : ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              if (context
                                  .watch<SearchProvider>()
                                  .nome
                                  .trim()
                                  .isEmpty) {
                                return Column(
                                  children: [
                                    ListTile(
                                      splashColor: Colors.deepPurple,
                                      leading: ProfilePicture(
                                        name: data["nome"],
                                        radius: 20,
                                        fontsize: 18,
                                      ),
                                      title: Text(
                                        data["nome"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
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
                                      tileColor: Colors.grey.shade900,
                                      shape: RoundedRectangleBorder(
                                        // side: BorderSide(
                                        // color: Colors.deepPurple, width: 1.5),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                );
                              }
                              if (data["nome"]
                                      .toString()
                                      .toLowerCase()
                                      .toString()
                                      .startsWith(context
                                          .read<SearchProvider>()
                                          .nome
                                          .toLowerCase()) ||
                                  data["nome"]
                                      .toString()
                                      .toLowerCase()
                                      .contains(context
                                          .read<SearchProvider>()
                                          .nome
                                          .toLowerCase())) {
                                return Column(
                                  children: [
                                    ListTile(
                                      splashColor: Colors.deepPurple,
                                      leading: ProfilePicture(
                                        name: data["nome"],
                                        radius: 20,
                                        fontsize: 18,
                                      ),
                                      title: Text(
                                        data["nome"],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis),
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
                                      tileColor: Colors.grey.shade900,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.deepPurple, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
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
          ],
        ),
      ),
    );
  }
}

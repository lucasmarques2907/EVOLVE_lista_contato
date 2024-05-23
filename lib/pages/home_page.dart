import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lista_contatos/pages/add_contact.dart';
import 'package:lista_contatos/pages/contact_page.dart';
import '../models/contact_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static List<ContactModel> Contacts = [
    ContactModel("1", "Rafael Raul Kevin das Neves", "(63)998301192"),
    ContactModel("2", "César Juan Moura", "(27)991977857"),
    ContactModel("3", "Liz Carolina Brito", "(21)997754316"),
    ContactModel("4", "Gabriela Eduarda Galvão", "(98)998491898"),
    ContactModel("5", "Clara Ester Corte Real", "(38)99192-7962"),
  ];

  List<ContactModel> foundContacts = [];

  @override
  void initState() {
    foundContacts = Contacts;
    super.initState();
  }

  void _runSearch(String enteredKeyword) {
    List<ContactModel> results = [];
    if (enteredKeyword.trim().isEmpty) {
      results = Contacts;
    } else {
      results = Contacts.where((contacts) =>
      contacts.username
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()) ||
          contacts.phone.contains(enteredKeyword)).toList();
    }

    setState(() {
      foundContacts = results;
    });
  }

  void deslogarUsuario(){
    FirebaseAuth.instance.signOut();
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
          IconButton(onPressed: deslogarUsuario, icon: const Icon(Icons.logout, color: Colors.white,))
        ],
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
                onChanged: (value) => _runSearch(value),
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
                child: ListView.builder(
                  itemCount: foundContacts.length,
                  itemBuilder: (context, index) => Card(
                    key: ValueKey(foundContacts[index].id),
                    color: Colors.grey.shade800,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: ProfilePicture(
                        name: foundContacts[index].username,
                        radius: 25,
                        fontsize: 21,
                        count: 1,
                      ),
                      title: Text(
                        foundContacts[index].username,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        foundContacts[index].phone,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactPage(id: foundContacts[index].id, contacts: foundContacts),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
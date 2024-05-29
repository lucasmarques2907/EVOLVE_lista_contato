import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lista_contatos/pages/edit_contact.dart';
import 'package:lista_contatos/service/database.dart';

class ContactPage extends StatefulWidget {
  final String id;

  const ContactPage({super.key, required this.id});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Widget _buildInfoContainer(
      BuildContext context, String label, String content) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade700),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              child: Icon(Icons.copy, color: Colors.deepPurple),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: content));
                Fluttertoast.showToast(
                  msg: "$label copiado",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.deepPurple,
                  textColor: Colors.white,
                  fontSize: 16,
                );
              },
            ),
          ),
          child: Text(
            content,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("Detalhes"),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 21, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Contato")
                      .where("id", isEqualTo: widget.id)
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
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
                                return Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Center(
                                      child: ProfilePicture(
                                        name: data["nome"],
                                        radius: 50,
                                        fontsize: 36,
                                        count: 1,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        data["nome"],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 24,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      data["celular"],
                                      style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 15),
                                    Column(
                                      children: [
                                        _buildInfoContainer(
                                            context, "Nome", data["nome"]),
                                        buildDivider(),
                                        _buildInfoContainer(context, "Celular",
                                            data["celular"]),
                                        buildDivider(),
                                        _buildInfoContainer(
                                            context, "CEP", data["cep"]),
                                        buildDivider(),
                                        _buildInfoContainer(
                                            context, "Estado", data["uf"]),
                                        buildDivider(),
                                        _buildInfoContainer(
                                            context, "Cidade", data["cidade"]),
                                        buildDivider(),
                                        _buildInfoContainer(
                                            context, "Bairro", data["bairro"]),
                                        buildDivider(),
                                        _buildInfoContainer(
                                            context, "Rua", data["rua"]),
                                        buildDivider(),
                                        _buildInfoContainer(
                                            context, "Número", data["numero"]),
                                        buildDivider(),
                                        _buildInfoContainer(context,
                                            "Complemento", data["complemento"]),
                                        SizedBox(height: 5),
                                      ],
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
              tileColor: Colors.white,
              title: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                CustomDialogWidget(id: widget.id.toString()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: Text(
                        "Excluir",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditContact(
                              id: widget.id.toString(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
                      child: Text(
                        "Editar",
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

  Divider buildDivider() {
    return const Divider(
      color: Colors.deepPurple,
      indent: 20,
      endIndent: 20,
    );
  }
}

class CustomDialogWidget extends StatelessWidget {
  final String id;

  const CustomDialogWidget({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_remove,
              size: 72,
              color: Colors.redAccent,
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Atenção!",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            const Text(
              "Deseja excluir este contato permanentemente?",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Não"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    Navigator.pop(context);
                    DatabaseMethods().excluirContato(id, context);
                  },
                  child: const Text("Sim"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lista_contatos/service/database.dart';

class ContactPage extends StatefulWidget {
  final String id;

  ContactPage({super.key, required this.id});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Widget _buildInfoContainer(
      BuildContext context, String label, String content) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none,
            suffixIcon: GestureDetector(
              child: Icon(Icons.copy, color: Colors.purple.shade300),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: content));
                Fluttertoast.showToast(
                  msg: "$label copiado",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.purple.shade600,
                  textColor: Colors.white,
                  fontSize: 16,
                );
              },
            ),
          ),
          child: Text(
            content,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
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
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection("Contato").snapshots(),
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
                                return Column(
                                  children: [
                                    SizedBox(height: 25),
                                    Center(
                                      child: ProfilePicture(
                                        name: data["nome"],
                                        radius: 50,
                                        fontsize: 36,
                                        count: 1,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      data["nome"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      data["celular"],
                                      style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 15),
                                    Column(
                                      children: [
                                        _buildInfoContainer(
                                            context, "Nome", data["nome"]),
                                        SizedBox(height: 5),
                                        _buildInfoContainer(context, "Celular",
                                            data["celular"]),
                                        SizedBox(height: 5),
                                        _buildInfoContainer(
                                            context, "CEP", data["cep"]),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        _buildInfoContainer(
                                            context, "Estado", data["uf"]),
                                        SizedBox(height: 5),
                                        _buildInfoContainer(
                                            context, "Cidade", data["cidade"]),
                                        SizedBox(height: 5),
                                        _buildInfoContainer(
                                            context, "Bairro", data["bairro"]),
                                        SizedBox(height: 5),
                                        _buildInfoContainer(
                                            context, "Rua", data["rua"]),
                                        SizedBox(height: 5),
                                        _buildInfoContainer(context,
                                            "Complemento", data["complemento"]),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                  ],
                                );
                              }
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
                        DatabaseMethods().excluirContato(widget.id, context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[500]),
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
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[500]),
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
}

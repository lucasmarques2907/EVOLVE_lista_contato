import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/contact_model.dart';

class ContactPage extends StatefulWidget {
  final String id;

  final List<ContactModel> contacts;

  ContactPage({super.key, required this.id, required this.contacts});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    // Buscar o contato usando o ID
    final ContactModel contact = widget.contacts.firstWhere((contact) => contact.id == widget.id);

    return Scaffold(
      backgroundColor: Colors.grey[900],
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
              child: ListView(
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: ProfilePicture(
                      name: contact.username,
                      radius: 50,
                      fontsize: 36,
                      count: 1,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    contact.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    contact.phone,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      _buildInfoContainer(context, "Nome", contact.username),
                      SizedBox(height: 5),
                      _buildInfoContainer(context, "Celular", contact.phone),
                      SizedBox(height: 5),
                      _buildInfoContainer(context, "CEP", "57309-770"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(BuildContext context, String label, String content) {
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
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{
  final usuarioAtual = FirebaseAuth.instance.currentUser;

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getDetalhesContato()async{
    return await FirebaseFirestore.instance.collection("Contato").where("UsuarioEmail", isEqualTo: usuarioAtual!.email!).snapshots();
  }
}
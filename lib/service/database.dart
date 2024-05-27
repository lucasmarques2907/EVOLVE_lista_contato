import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  Future excluirContato(String id, context)async{
    await FirebaseFirestore.instance.collection("Contato").doc(id).delete();
    return Navigator.of(context).pop();
  }

  Future atualizarContato(String id, Map<String, dynamic> atualizarInfo, context) async {
    await FirebaseFirestore.instance.collection("Contato").doc(id).update(atualizarInfo);
    return Navigator.of(context).pop();
  }
}


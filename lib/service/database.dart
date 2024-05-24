import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  Future excluirContato(String id, context)async{
    await FirebaseFirestore.instance.collection("Contato").doc(id).delete();
    return Navigator.of(context).pop();
  }
}
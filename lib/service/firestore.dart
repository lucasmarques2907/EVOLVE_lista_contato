import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService{
  final CollectionReference contatos =
      FirebaseFirestore.instance.collection('contatos');
}
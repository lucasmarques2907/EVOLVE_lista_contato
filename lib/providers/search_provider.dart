import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String nome;

  SearchProvider({
    this.nome = "",
  });

  void filtrarContatos({
    required String pesquisa,
  }) async {
    nome = pesquisa;
    notifyListeners();
  }
}
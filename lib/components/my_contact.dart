import 'package:flutter/material.dart';

class MyContact extends StatelessWidget {
  final String nome;
  final String celular;

  const MyContact({
    super.key,
    required this.nome,
    required this.celular,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(nome),
            Text(celular),
          ],
        )
      ],
    );
  }
}

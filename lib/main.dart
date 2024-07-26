import 'package:cadastro_crud/views/usuario_form.dart';
import 'package:cadastro_crud/views/usuario_lista.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Cadastro SQLITE',
        debugShowCheckedModeBanner: false,
        home: UsuarioLista());
  }
}


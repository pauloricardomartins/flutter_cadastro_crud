// import 'dart:convert';

class Usuario {
  final int id;
  final String nome;
  final String email;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
  });

  //factory
  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    nome: json['nome'],
    email: json['email'],
  );

  //método que converte um o objeto em um mapa
  Map<String, dynamic> toMap() => {'id': id, 'nome': nome, 'email': email};
}

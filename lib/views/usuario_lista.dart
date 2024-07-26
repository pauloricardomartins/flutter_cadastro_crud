import 'package:flutter/material.dart';
import 'package:cadastro_crud/models/usuario.dart';
import 'package:cadastro_crud/database/db.dart';
import 'package:cadastro_crud/views/usuario_form.dart';

class UsuarioLista extends StatefulWidget {
  const UsuarioLista({super.key});

  @override
  State<UsuarioLista> createState() => _UsuarioListaState();
}

class _UsuarioListaState extends State<UsuarioLista> {
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    final List<Usuario> usuariosCarregados = await DB().allUsuarios();
    setState(() {
      usuarios = usuariosCarregados;
    });
  }

  Future<void> _confirmarDelecao(BuildContext context, Usuario usuario) async {
    final bool? confirmacao = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza de que deseja excluir este usuário?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela a exclusão
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma a exclusão
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmacao == true) {
      await DB().deleteUsuario(usuario.id);
      _carregarUsuarios();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const UsuarioForm(),
                    ),
                  )
                  .then((_) => _carregarUsuarios());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (ctx, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario.nome),
            subtitle: Text(usuario.email),
            trailing: Container(
              width: 100.0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) => UsuarioForm(usuario: usuario),
                            ),
                          )
                          .then((_) => _carregarUsuarios());
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _confirmarDelecao(context, usuario);
                    },
                    color: Colors.red,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
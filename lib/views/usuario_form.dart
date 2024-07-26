import 'package:flutter/material.dart';
import 'package:cadastro_crud/database/db.dart';
import 'package:cadastro_crud/models/usuario.dart';
import 'package:email_validator/email_validator.dart';


class UsuarioForm extends StatefulWidget {
  final Usuario? usuario;
  const UsuarioForm({Key? key, this.usuario});

  @override
  State<UsuarioForm> createState() => _UsuarioFormState();
}

class _UsuarioFormState extends State<UsuarioForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      _nomeController.text = widget.usuario!.nome;
      _emailController.text = widget.usuario!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.usuario == null ? 'Novo Usuário' : 'Editar Usuários'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, insira o nome";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor, insira o e-mail";
                }
                if(!EmailValidator.validate(value)) {
                   return "E-mail inválido!";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final id = widget.usuario?.id ??
                      DateTime.now().millisecondsSinceEpoch;
                  final nome = _nomeController.text;
                  final email = _emailController.text;
                  final novoUsuario = Usuario(id: id, nome: nome, email: email);
                  if (widget.usuario == null) {
                    await DB().createUsuario(novoUsuario);
                  } else {
                    await DB().updateUsuario(novoUsuario);
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            )
          ]),
        ),
      ),
    );
  }
}

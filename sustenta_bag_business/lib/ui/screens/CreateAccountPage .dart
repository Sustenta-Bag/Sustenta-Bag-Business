import 'package:flutter/material.dart';

import '../../widgets/CustomTextField.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmSenhaController = TextEditingController();

  Future<void> _criarConta() async {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmSenha = _confirmSenhaController.text;

    if (email.isNotEmpty && senha.isNotEmpty && confirmSenha.isNotEmpty) {
      if (senha == confirmSenha) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        _showErrorDialog('As senhas não coincidem.');
      }
    } else {
      _showErrorDialog('Preencha todos os campos.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextField(controller: _emailController, label: 'Email'),
                  SizedBox(height: 20),
                  CustomTextField(controller: _senhaController, label: 'Senha', obscureText: true),
                  SizedBox(height: 20),
                  CustomTextField(controller: _confirmSenhaController, label: 'Confirmar Senha', obscureText: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _criarConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 12),
                    ),
                    child: const Text(
                      'CRIAR CONTA',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

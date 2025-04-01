import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sustenta_bag_business/ui/screens/CreateAccountPage%20.dart';
import '../../widgets/CustomButton.dart';
import '../../widgets/CustomTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _loginController.text;
    String senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        _showErrorDialog('Preencha os campos de login e senha.');
      }
      return;
    }

    try {
     
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Erro ao fazer login: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                  const SizedBox(height: 20),
                  Image.asset('assets/images/img1.png', height: 220),
                  const Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF225C4B),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(controller: _loginController, label: 'Login'),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _senhaController,
                    label: 'Senha',
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  _isLoading 
                      ? const CircularProgressIndicator(color: Color(0xFF225C4B))
                      : CustomButton(onPressed: _login, text: 'Entrar'),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: 'Não possui uma conta? ',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Inscreva-se',
                          style: const TextStyle(
                            color: Color(0xFF225C4B),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              const CreateAccountPage(),
                                    ),
                                  );
                                },
                        ),
                      ],
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
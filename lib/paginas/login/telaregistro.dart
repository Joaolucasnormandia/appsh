import 'package:appsh/paginas/login/detalheusuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_passwordController.text.trim() !=
            _confirmPasswordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('As senhas não coincidem.')),
          );
          return;
        }

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? currentUser = userCredential.user;

        if (currentUser != null && !currentUser.emailVerified) {
          await currentUser.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Registro bem-sucedido. Verifique seu e-mail para continuar.'),
            ),
          );
        }

        bool isEmailVerified = false;
        while (!isEmailVerified) {
          await Future.delayed(const Duration(seconds: 3));
          await currentUser?.reload();
          currentUser = FirebaseAuth.instance.currentUser;
          isEmailVerified = currentUser?.emailVerified ?? false;
        }

        if (isEmailVerified) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .set({'email': currentUser.email});

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetalheCadastroScreen(uid: currentUser!.uid),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Erro desconhecido. Tente novamente.';
        if (e.code == 'weak-password') {
          message = 'A senha deve ter pelo menos 6 caracteres.';
        } else if (e.code == 'email-already-in-use') {
          message = 'Este e-mail já está registrado.';
        } else if (e.code == 'invalid-email') {
          message = 'O e-mail fornecido é inválido.';
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(
                controller: _emailController,
                label: 'E-mail',
                hintText: 'Digite seu e-mail',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe um e-mail válido.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'O e-mail informado é inválido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: 'Senha',
                hintText: 'Digite sua senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma senha.';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirmar Senha',
                hintText: 'Digite sua senha novamente',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha.';
                  }
                  if (value != _passwordController.text) {
                    return 'As senhas não coincidem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _register,
                      child: const Text('Registrar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetalheCadastroScreen extends StatefulWidget {
  final String uid;
  DetalheCadastroScreen({required this.uid});

  @override
  _DetalheCadastroScreenState createState() => _DetalheCadastroScreenState();
}

class _DetalheCadastroScreenState extends State<DetalheCadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _saveNome() async {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu nome.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'nome': _nomeController.text,
      }, SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o nome.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSexo(String sexo) async {
    if (sexo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu sexo.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'sexo': sexo,
      }, SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o sexo.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveDataNascimento() async {
    if (_dataNascimentoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, insira sua data de nascimento.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'dataNascimento': _dataNascimentoController.text,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro completo!')),
      );
      // Aqui você pode redirecionar o usuário para outra tela
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar a data de nascimento.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Detalhes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nome
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Gênero
              Text(
                'Selecione seu Gênero:',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGenderButton(
                    'Masculino',
                    'assets/icons/masculino.png',
                    () => _saveSexo('Masculino'),
                  ),
                  _buildGenderButton(
                    'Feminino',
                    'assets/icons/femenino.png',
                    () => _saveSexo('Feminino'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Data de Nascimento
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  hintText: 'dd/mm/aaaa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua data de nascimento.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Concluir
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveDataNascimento,
                      child: const Text('Concluir'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderButton(
      String label, String imagePath, VoidCallback onPressed) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitHeight,
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}

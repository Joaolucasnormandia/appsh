import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication

class DiarioFormPage extends StatefulWidget {
  final String dia;
  final String? anotacaoExistente;

  DiarioFormPage({required this.dia, this.anotacaoExistente});

  @override
  _DiarioFormPageState createState() => _DiarioFormPageState();
}

class _DiarioFormPageState extends State<DiarioFormPage> {
  final TextEditingController _humorController = TextEditingController();
  final TextEditingController _atividadesController = TextEditingController();
  final TextEditingController _alimentacaoController = TextEditingController();
  final TextEditingController _notasController = TextEditingController();
  final TextEditingController _aguaController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    if (_currentUser == null) return;

    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firestore
          .collection('diarios')
          .doc(_currentUser.uid)
          .collection('dias')
          .doc(widget.dia)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          _humorController.text = data['humor'] ?? '';
          _atividadesController.text = data['atividades'] ?? '';
          _alimentacaoController.text = data['alimentacao'] ?? '';
          _notasController.text = data['notas'] ?? '';
          _aguaController.text = data['agua']?.toString() ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _saveData() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    if (_humorController.text.isEmpty ||
        _atividadesController.text.isEmpty ||
        _alimentacaoController.text.isEmpty ||
        _aguaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos antes de salvar.')),
      );
      return;
    }

    if (double.tryParse(_aguaController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira um valor válido para a quantidade de água.')),
      );
      return;
    }

    try {
      await _firestore
          .collection('diarios')
          .doc(_currentUser.uid)
          .collection('dias')
          .doc(widget.dia)
          .set({
        'humor': _humorController.text,
        'atividades': _atividadesController.text,
        'alimentacao': _alimentacaoController.text,
        'notas': _notasController.text,
        'agua': double.parse(_aguaController.text),
        'dataSalva': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anotação salva!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar dados: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.dia,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Como você se sentiu hoje?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _humorController,
                decoration: InputDecoration(
                  hintText: 'Descreva seu humor...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Text(
                'Atividades realizadas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _atividadesController,
                decoration: InputDecoration(
                  hintText: 'Descreva suas atividades...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Text(
                'Alimentação:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _alimentacaoController,
                decoration: InputDecoration(
                  hintText: 'O que você comeu hoje?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Text(
                'Quantos litros de água você bebeu hoje?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _aguaController,
                decoration: InputDecoration(
                  hintText: 'Informe a quantidade em Litros...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Text(
                'Notas:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _notasController,
                decoration: InputDecoration(
                  hintText: 'Adicione observações extras...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: _saveData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

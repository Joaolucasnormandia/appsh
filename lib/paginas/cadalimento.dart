import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CadastroAlimentoScreen extends StatefulWidget {
  @override
  _CadastroAlimentoScreenState createState() => _CadastroAlimentoScreenState();
}

class _CadastroAlimentoScreenState extends State<CadastroAlimentoScreen> {
  final _nomeController = TextEditingController();
  final _caloriasController = TextEditingController();
  final _proteinaController = TextEditingController();
  final _carboidratoController = TextEditingController();
  final _gorduraSaudavelController = TextEditingController();
  final _gorduraTransController = TextEditingController();
  final _calcioController = TextEditingController();
  final _ferroController = TextEditingController();
  final _vitaminaCController = TextEditingController();
  final _fibraController = TextEditingController();
  final _sodioController = TextEditingController();

  String _categoriaSelecionada = 'Comida';
  bool _isLoading = false;

  Future<void> _saveFood() async {
    String nome = _nomeController.text.trim();
    int calorias = int.tryParse(_caloriasController.text) ?? 0;
    int proteina = int.tryParse(_proteinaController.text) ?? 0;
    int carboidrato = int.tryParse(_carboidratoController.text) ?? 0;
    int gorduraSaudavel = int.tryParse(_gorduraSaudavelController.text) ?? 0;
    int gorduraTrans = int.tryParse(_gorduraTransController.text) ?? 0;
    int calcio = int.tryParse(_calcioController.text) ?? 0;
    int ferro = int.tryParse(_ferroController.text) ?? 0;
    int vitaminaC = int.tryParse(_vitaminaCController.text) ?? 0;
    int fibra = int.tryParse(_fibraController.text) ?? 0;
    int sodio = int.tryParse(_sodioController.text) ?? 0;

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira o nome do alimento.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String uidAlimento = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance
          .collection('foods')
          .doc(uidAlimento)
          .set({
        'uid': uidAlimento,
        'nome': nome,
        'calorias': calorias,
        'proteina': proteina,
        'carboidrato': carboidrato,
        'gorduraSaudavel': gorduraSaudavel,
        'gorduraTrans': gorduraTrans,
        'calcio': calcio,
        'ferro': ferro,
        'vitaminaC': vitaminaC,
        'fibra': fibra,
        'sodio': sodio,
        'categoria': _categoriaSelecionada,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alimento cadastrado com sucesso!')),
      );
      _nomeController.clear();
      _caloriasController.clear();
      _proteinaController.clear();
      _carboidratoController.clear();
      _gorduraSaudavelController.clear();
      _gorduraTransController.clear();
      _calcioController.clear();
      _ferroController.clear();
      _vitaminaCController.clear();
      _fibraController.clear();
      _sodioController.clear();
      setState(() {
        _categoriaSelecionada = 'Comida';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar o alimento.')),
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
      appBar: AppBar(title: Text('Cadastro de Alimento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Alimento'),
            ),
            TextField(
              controller: _caloriasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Calorias'),
            ),
            TextField(
              controller: _proteinaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Proteínas (g)'),
            ),
            TextField(
              controller: _carboidratoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Carboidratos (g)'),
            ),
            TextField(
              controller: _gorduraSaudavelController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Gorduras Saudáveis (g)'),
            ),
            TextField(
              controller: _gorduraTransController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Gordura Trans (g)'),
            ),
            TextField(
              controller: _calcioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cálcio (mg)'),
            ),
            TextField(
              controller: _ferroController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ferro (mg)'),
            ),
            TextField(
              controller: _vitaminaCController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Vitamina C (mg)'),
            ),
            TextField(
              controller: _fibraController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Fibra (g)'),
            ),
            TextField(
              controller: _sodioController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Sódio (mg)'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _categoriaSelecionada,
              onChanged: (String? novaCategoria) {
                setState(() {
                  _categoriaSelecionada = novaCategoria!;
                });
              },
              items: ['Comida', 'Bebida']
                  .map((categoria) => DropdownMenuItem(
                        value: categoria,
                        child: Text(categoria),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveFood,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Cadastrar Alimento'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  

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

  @override
  void initState() {
    super.initState();
    _carregarDados(); 
  }

  void _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _humorController.text = prefs.getString('humor_${widget.dia}') ?? '';
      _atividadesController.text = prefs.getString('atividades_${widget.dia}') ?? '';
      _alimentacaoController.text = prefs.getString('alimentacao_${widget.dia}') ?? '';
      _notasController.text = prefs.getString('notas_${widget.dia}') ?? '';
      _aguaController.text = prefs.getString('agua_${widget.dia}') ?? ''; 
    });
  }

 void _saveData() async {
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

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('humor_${widget.dia}', _humorController.text);
  await prefs.setString('atividades_${widget.dia}', _atividadesController.text);
  await prefs.setString('alimentacao_${widget.dia}', _alimentacaoController.text);
  await prefs.setString('notas_${widget.dia}', _notasController.text);
  await prefs.setString('agua_${widget.dia}', _aguaController.text); 

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Anotação salva!')),
  );

  Navigator.pop(context, true);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    widget.dia,
    style: TextStyle(
      color: Colors.white, // Mudando a cor do título para branco
    ),
  ),
  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
   iconTheme: IconThemeData(
    color: Colors.white, // Mudando a cor da seta de voltar para branco
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
                  hintText: 'Informe a quantidade em Litros   ...',
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
                  color: Colors.white, // Mudando a cor do texto "Salvar" para branco
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

import 'package:flutter/material.dart';

void main() {
  runApp(IMCApp());
}

class IMCApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: TelaIMC(),
    );
  }
}

class TelaIMC extends StatefulWidget {
  @override
  _TelaIMCState createState() => _TelaIMCState();
}

class _TelaIMCState extends State<TelaIMC> {
  final _formKey = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  void _calcularIMC() {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text.replaceAll(',', '.'));
      final altura = double.parse(_alturaController.text.replaceAll(',', '.'));
      final imc = peso / (altura * altura);

      String avaliacao;
      Color corAviso;
      String emoji;
      if (imc < 18.5) {
        avaliacao = "Abaixo do peso";
        corAviso = Colors.orange;
        emoji = "⚠️";
      } else if (imc < 24.9) {
        avaliacao = "Peso normal";
        corAviso = Colors.green;
        emoji = "✅";
      } else if (imc < 29.9) {
        avaliacao = "Sobrepeso";
        corAviso = Colors.orange;
        emoji = "⚠️";
      } else {
        avaliacao = "Obesidade";
        corAviso = Colors.red;
        emoji = "❌";
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaResultado(
            imc: imc,
            avaliacao: avaliacao,
            corAviso: corAviso,
            emoji: emoji,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Informe seus dados:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Peso (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.monitor_weight),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o peso';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Insira um número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _alturaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Altura (m)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    prefixIcon: Icon(Icons.height),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a altura';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Insira um número válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _calcularIMC,
                  child: Text(
                    'Calcular IMC',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TelaResultado extends StatelessWidget {
  final double imc;
  final String avaliacao;
  final Color corAviso;
  final String emoji;

  TelaResultado({
    required this.imc,
    required this.avaliacao,
    required this.corAviso,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado do IMC'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Seu IMC é:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                imc.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                '$emoji $avaliacao',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: corAviso,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                '⚠️ Este cálculo não substitui uma consulta médica.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Atualizar',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

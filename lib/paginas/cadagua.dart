import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalcularAgua extends StatefulWidget {
  @override
  _CalcularAguaState createState() => _CalcularAguaState();
}

class _CalcularAguaState extends State<CalcularAgua> {
  final TextEditingController _pesoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double _calcularAgua(double peso) {
    return peso * 35;
  }

  Future<void> _salvarDados(double quantidadeAgua) async {
    User? user = _auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      String data = DateTime.now().toIso8601String().split('T')[0];

      CollectionReference colecao =
          FirebaseFirestore.instance.collection('agua_calculada');

      QuerySnapshot querySnapshot =
          await colecao.where('userId', isEqualTo: uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documento = querySnapshot.docs.first;
        await colecao.doc(documento.id).update({
          'quantidadeAgua': quantidadeAgua,
          'data': data,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
      } else {
        await colecao.add({
          'userId': uid,
          'quantidadeAgua': quantidadeAgua,
          'data': data,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular Quantidade de Água'),
        centerTitle: true,
        backgroundColor: isDarkMode ? const Color(0xFF1E2952) : Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Digite o seu peso para calcular a quantidade de água necessária:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String pesoText = _pesoController.text;
                if (pesoText.isNotEmpty) {
                  double peso = double.tryParse(pesoText) ?? 0.0;

                  if (peso > 0) {
                    double quantidadeAgua = _calcularAgua(peso);
                    _salvarDados(quantidadeAgua);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Peso inválido.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, insira seu peso.')),
                  );
                }
              },
              child: const Text('Calcular e Registrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? const Color(0xFF1E2952) : Colors.teal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: isDarkMode ? const Color(0xFF1E2952) : Colors.white,
    );
  }
}

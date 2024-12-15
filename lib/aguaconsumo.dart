import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AguaConsumo extends StatefulWidget {
  const AguaConsumo({Key? key}) : super(key: key);

  @override
  _AguaConsumoState createState() => _AguaConsumoState();
}

class _AguaConsumoState extends State<AguaConsumo> {
  int quantidadeAgua = 100; // Inicializar com 100ml (exemplo)
  final int maxAgua = 12000; // Limite máximo de 12L
  final int alertaLimite = 6000; // Alerta se o consumo for maior que 6L

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Consumo de Água'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/iconeagua.png',
              height: 80, 
              width: 80,
            ),
            const SizedBox(height: 20),
            // Exibindo a quantidade de água em litros sem arredondamento
            Text(
              '${(quantidadeAgua / 1000).toStringAsFixed(1)} L', // 100 ml = 0.1 L sem arredondamento extra
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Digite a quantidade de água consumida (ml):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade de Água (ml)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  quantidadeAgua = int.tryParse(value) ?? 0; // Garantir que o valor seja válido
                });
              },
              controller: TextEditingController(text: quantidadeAgua.toString()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (quantidadeAgua > maxAgua) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Limite máximo de consumo atingido!')),
                  );
                  return;
                }

                if (quantidadeAgua > alertaLimite) {
                  _mostrarAlertaHiperidratacao();
                } else {
                  await _registrarConsumoDeAgua(quantidadeAgua);
                }
              },
              child: const Text('Registrar Consumo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrarConsumoDeAgua(int quantidade) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    final userId = user.uid;
    final dataAtual = DateTime.now();
    final dataAtualFormatada = DateTime(dataAtual.year, dataAtual.month, dataAtual.day); // Ignorando hora, minuto e segundo

    try {
      // Verificar se já existe um consumo registrado na mesma data
      final querySnapshot = await FirebaseFirestore.instance
          .collection('consumos')
          .where('uid_usuario', isEqualTo: userId)
          .where('data_consumo', isEqualTo: dataAtualFormatada)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se já houver um consumo registrado, pegar o consumo existente
        final doc = querySnapshot.docs.first;
        final consumoExistente = doc.data() as Map<String, dynamic>;
        final quantidadeExistente = consumoExistente['quantidade_ml'] ?? 0;

        // Atualizar o consumo somando o valor atual
        await FirebaseFirestore.instance.collection('consumos').doc(doc.id).update({
          'quantidade_ml': quantidadeExistente + quantidade,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consumo de água atualizado com sucesso!')),
        );
      } else {
        // Se não houver registro, criar um novo
        await FirebaseFirestore.instance.collection('consumos').add({
          'uid_usuario': userId,
          'data_consumo': dataAtualFormatada,
          'quantidade_ml': quantidade,
          'agua': true, 
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consumo de água registrado com sucesso!')),
        );
      }
    } catch (e) {
      print("Erro ao registrar consumo: $e"); // Log de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar consumo: $e')),
      );
    }
  }

  void _mostrarAlertaHiperidratacao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção!'),
          content: const Text(
            'Você está prestes a consumir mais de 6 litros de água. '
            'A ingestão excessiva pode levar à hiperidratação e intoxicação por água, '
            'o que pode ser perigoso para sua saúde. Consulte um profissional de saúde se necessário.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

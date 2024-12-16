import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaloriasScreen extends StatefulWidget {
  @override
  _CaloriasScreenState createState() => _CaloriasScreenState();
}

class _CaloriasScreenState extends State<CaloriasScreen> {
  // Variáveis para armazenar os totais de nutrientes
  double _caloriasTotais = 0;
  double _proteinasTotais = 0;
  double _carboidratosTotais = 0;
  double _gordurasTotais = 0;
  double _fibraTotais = 0;
  double _sodioTotais = 0;
  double _vitaminaCTotais = 0;
  double _calcioTotais = 0;
  double _gorduraTransTotais = 0;

  @override
  void initState() {
    super.initState();
    _calcularNutrientes();
  }

  Future<void> _calcularNutrientes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    final userId = user.uid; // ID do usuário logado
    final dataAtual = DateTime.now();
    final dataFormatada = DateTime(
      dataAtual.year,
      dataAtual.month,
      dataAtual.day,
    );

    try {
      // Inicializando as variáveis para totalizar os nutrientes
      double caloriasTotais = 0;
      double proteinasTotais = 0;
      double carboidratosTotais = 0;
      double gordurasTotais = 0;
      double fibraTotais = 0;
      double sodioTotais = 0;
      double vitaminaCTotais = 0;
      double calcioTotais = 0;
      double gorduraTransTotais = 0;

      // Busca todos os consumos do usuário
      final consumosSnapshot = await FirebaseFirestore.instance
          .collection('consumos')
          .where('uid_usuario', isEqualTo: userId)
          .get();

      for (var doc in consumosSnapshot.docs) {
        final dadosConsumo = doc.data();
        final dataConsumo =
            (dadosConsumo['data_consumo'] as Timestamp).toDate();

        // Verifica se a data do consumo é a data atual
        if (dataConsumo.year == dataFormatada.year &&
            dataConsumo.month == dataFormatada.month &&
            dataConsumo.day == dataFormatada.day) {
          final uidAlimento = dadosConsumo['uid_alimento'];

          if (uidAlimento != null) {
            // Busca as informações do alimento na coleção 'foods' usando o uid_alimento
            final alimentoSnapshot = await FirebaseFirestore.instance
                .collection('foods')
                .doc(uidAlimento)
                .get();

            if (alimentoSnapshot.exists) {
              final dadosAlimento = alimentoSnapshot.data();

              // Somando todos os nutrientes ao total
              caloriasTotais +=
                  (dadosAlimento?['calorias'] as num?)?.toDouble() ?? 0.0;
              proteinasTotais +=
                  (dadosAlimento?['proteinas'] as num?)?.toDouble() ?? 0.0;
              carboidratosTotais +=
                  (dadosAlimento?['carboidratos'] as num?)?.toDouble() ?? 0.0;
              gordurasTotais +=
                  (dadosAlimento?['gorduras'] as num?)?.toDouble() ?? 0.0;
              fibraTotais +=
                  (dadosAlimento?['fibra'] as num?)?.toDouble() ?? 0.0;
              sodioTotais +=
                  (dadosAlimento?['sodio'] as num?)?.toDouble() ?? 0.0;
              vitaminaCTotais +=
                  (dadosAlimento?['vitaminaC'] as num?)?.toDouble() ?? 0.0;
              calcioTotais +=
                  (dadosAlimento?['calcio'] as num?)?.toDouble() ?? 0.0;
              gorduraTransTotais +=
                  (dadosAlimento?['gorduraTrans'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }

      // Atualiza o estado com os valores totais
      setState(() {
        _caloriasTotais = caloriasTotais;
        _proteinasTotais = proteinasTotais;
        _carboidratosTotais = carboidratosTotais;
        _gordurasTotais = gordurasTotais;
        _fibraTotais = fibraTotais;
        _sodioTotais = sodioTotais;
        _vitaminaCTotais = vitaminaCTotais;
        _calcioTotais = calcioTotais;
        _gorduraTransTotais = gorduraTransTotais;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao calcular nutrientes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micronutrientes Consumidos'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Valores nutricionais totais consumidos hoje:',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildNutrienteRow('Calorias', _caloriasTotais, 'kcal'),
            _buildNutrienteRow('Proteínas', _proteinasTotais, 'g'),
            _buildNutrienteRow('Carboidratos', _carboidratosTotais, 'g'),
            _buildNutrienteRow('Gorduras', _gordurasTotais, 'g'),
            _buildNutrienteRow('Fibra', _fibraTotais, 'g'),
            _buildNutrienteRow('Sódio', _sodioTotais, 'mg'),
            _buildNutrienteRow('Vitamina C', _vitaminaCTotais, 'mg'),
            _buildNutrienteRow('Cálcio', _calcioTotais, 'mg'),
            _buildNutrienteRow('Gordura Trans', _gorduraTransTotais, 'g'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrienteRow(String nome, double valor, String unidade) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nome,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$valor $unidade',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}

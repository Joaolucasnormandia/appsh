import 'package:appsh/listaralimento.dart';
import 'package:appsh/paginas/cadagua.dart';
import 'package:appsh/paginas/calo.dart';
import 'package:appsh/paginas/imc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Corpo extends StatefulWidget {
  @override
  _CorpoState createState() => _CorpoState();
}

class _CorpoState extends State<Corpo> {
  String _getImagemProgresso(double progresso) {
    if (progresso >= 100) return 'assets/icons/iconecopo/copo5.png';
    if (progresso >= 75) return 'assets/icons/iconecopo/copo4.png';
    if (progresso >= 50) return 'assets/icons/iconecopo/copo3.png';
    if (progresso >= 25) return 'assets/icons/iconecopo/copo2.png';
    if (progresso >= 15) return 'assets/icons/iconecopo/copo1.png';
    return 'assets/icons/iconecopo/copo0.png';
  }

  Future<void> _registrarConsumo(int quantidade) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    final userId = user.uid;
    final dataAtual = DateTime.now();
    final dataFormatada =
        DateTime(dataAtual.year, dataAtual.month, dataAtual.day);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('consumos')
          .where('uid_usuario', isEqualTo: userId)
          .where('data_consumo', isEqualTo: dataFormatada)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final consumoExistente = doc.data() as Map<String, dynamic>;
        final quantidadeExistente = consumoExistente['quantidade_ml'] ?? 0;
        await FirebaseFirestore.instance
            .collection('consumos')
            .doc(doc.id)
            .update({'quantidade_ml': quantidadeExistente + quantidade});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Consumo de água atualizado com sucesso!')),
        );
      } else {
        await FirebaseFirestore.instance.collection('consumos').add({
          'uid_usuario': userId,
          'data_consumo': dataFormatada,
          'quantidade_ml': quantidade,
          'agua': true,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Consumo de água registrado com sucesso!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao registrar consumo: $e')),
      );
    }
  }

  Future<double> calcularCalorias() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }
    final userId = user.uid;
    final dataAtual = DateTime.now();
    final dataFormatada = DateTime(
      dataAtual.year,
      dataAtual.month,
      dataAtual.day,
    );
    try {
      double caloriasTotais = 0;
      final consumosSnapshot = await FirebaseFirestore.instance
          .collection('consumos')
          .where('uid_usuario', isEqualTo: userId)
          .get();
      for (var doc in consumosSnapshot.docs) {
        final dadosConsumo = doc.data();
        final dataConsumo =
            (dadosConsumo['data_consumo'] as Timestamp).toDate();
        if (dataConsumo.year == dataFormatada.year &&
            dataConsumo.month == dataFormatada.month &&
            dataConsumo.day == dataFormatada.day) {
          final uidAlimento = dadosConsumo['uid_alimento'];
          if (uidAlimento != null) {
            final alimentoSnapshot = await FirebaseFirestore.instance
                .collection('foods')
                .doc(uidAlimento)
                .get();

            if (alimentoSnapshot.exists) {
              final dadosAlimento = alimentoSnapshot.data();
              caloriasTotais +=
                  (dadosAlimento?['calorias'] as num?)?.toDouble() ?? 0.0;
            }
          }
        }
      }

      return caloriasTotais;
    } catch (e) {
      throw Exception('Erro ao calcular calorias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: CircularProgressIndicator());
    }

    final userId = user.uid;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            isDarkMode ? const Color.fromARGB(255, 21, 30, 59) : Colors.teal,
        title: Row(
          children: [
            Image.asset('assets/icons/iconetelasaude.gif',
                width: 50, height: 50),
            const SizedBox(width: 10),
            const Text('Saúde Física',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: isDarkMode
              ? const Color(0xFF1E2952)
              : const Color.fromARGB(255, 252, 241, 232),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x39000000),
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ],
                  ),
                  height: 370,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Cálculo ',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E2952))),
                          const SizedBox(height: 16),
                          _buildActionButton(IMCApp(), 'assets/icons/imc.png'),
                          const SizedBox(height: 20),
                          _buildActionButton(
                              CalcularAgua(), 'assets/icons/calcularagua.png'),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Container(width: 2, height: 300, color: Colors.grey[600]),
                      const SizedBox(width: 10),
                      _buildConsumoWidget(userId),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4))
                  ],
                ),
                child: FutureBuilder<double>(
                  future: calcularCalorias(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Calculando calorias...',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    } else {
                      final calorias = snapshot.data ?? 0.0;
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildButton(
                                  "Listar Alimentos",
                                  () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListarAlimentosScreen())),
                                  'assets/icons/comidaadd.png',
                                ),
                                const SizedBox(height: 10),
                                _buildButton(
                                  "Micronutrientes",
                                  () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CaloriasScreen())),
                                  'assets/icons/livroicone.png',
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 13,
                            color: Color.fromARGB(255, 0, 0, 0),
                            width: 140,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Micro',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E2952)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${calorias.toStringAsFixed(2)} kcal',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Image.asset(
                                  'assets/icons/fogoicone.png',
                                  height: 70,
                                  width: 70,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildActionButton(Widget screen, String iconPath) {
    return ElevatedButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => screen)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Image.asset(iconPath, height: 95, width: 95),
    );
  }

  StreamBuilder<QuerySnapshot> _buildConsumoWidget(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('agua_calculada')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshotAguaCalculada) {
        if (!snapshotAguaCalculada.hasData)
          return const CircularProgressIndicator();
        final docsAguaCalculada = snapshotAguaCalculada.data!.docs;
        if (docsAguaCalculada.isEmpty)
          return const Text('Nenhuma meta de água encontrada');
        final dados = docsAguaCalculada.first.data() as Map<String, dynamic>;
        final quantidadeMetaAguaMl = dados['quantidadeAgua'] ?? 0;
        final quantidadeMetaAgua = quantidadeMetaAguaMl / 1000;
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('consumos')
              .where('uid_usuario', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshotConsumo) {
            if (!snapshotConsumo.hasData)
              return const CircularProgressIndicator();
            final docsConsumo = snapshotConsumo.data!.docs;
            double consumoAtualMl = 0;
            final today = DateTime.now();

            for (var doc in docsConsumo) {
              final dadosConsumo = doc.data() as Map<String, dynamic>;
              final dataConsumo =
                  (dadosConsumo['data_consumo'] as Timestamp).toDate();
              if (dataConsumo.year == today.year &&
                  dataConsumo.month == today.month &&
                  dataConsumo.day == today.day) {
                consumoAtualMl +=
                    (dadosConsumo['quantidade_ml'] ?? 0).toDouble();
              }
            }

            final consumoAtualLitros = consumoAtualMl / 1000;
            final progresso = (consumoAtualLitros / quantidadeMetaAgua) * 100;

            return Column(
              children: [
                const Text('Consumo de Água',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2952))),
                const SizedBox(height: 10),
                Image.asset(_getImagemProgresso(progresso),
                    height: 150, width: 150),
                const SizedBox(height: 10),
                Text(
                    '${consumoAtualLitros.toStringAsFixed(2)} L / ${quantidadeMetaAgua.toStringAsFixed(2)} L',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E2952))),
                const SizedBox(height: 10),
                _buildConsumirButtons(),
              ],
            );
          },
        );
      },
    );
  }

  Row _buildConsumirButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildConsumirButton(50),
        _buildConsumirButton(100),
        _buildConsumirButton(250),
      ],
    );
  }

  TextButton _buildConsumirButton(int quantidade) {
    return TextButton(
      onPressed: () => _registrarConsumo(quantidade),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Image.asset(
        'assets/icons/iconeagua$quantidade.png',
        height: 40,
        width: 40,
      ),
    );
  }

  ElevatedButton _buildButton(
      String label, VoidCallback onPressed, String iconPath) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        children: [
          Image.asset(iconPath, height: 50, width: 50),
          Text(label, style: TextStyle(fontSize: 16, color: Color(0xFF1E2952))),
        ],
      ),
    );
  }
}

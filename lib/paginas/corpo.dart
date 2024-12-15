import 'package:appsh/paginas/cadagua.dart';
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
        backgroundColor: isDarkMode ? const Color(0xFF1E2952) : Colors.teal,
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
      body: Container(
        color: isDarkMode
            ? const Color(0xFF1E2952)
            : const Color.fromARGB(255, 252, 241, 232),
        child: Stack(
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
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4))
                  ],
                ),
                height: 320,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cálculo',
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
                    const SizedBox(width: 20),
                    Container(width: 2, height: 300, color: Colors.grey[600]),
                    const SizedBox(width: 20),
                    _buildConsumoWidget(userId),
                  ],
                ),
              ),
            ),
          ],
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

            for (var doc in docsConsumo) {
              final dadosConsumo = doc.data() as Map<String, dynamic>;
              consumoAtualMl += (dadosConsumo['quantidade_ml'] ?? 0).toDouble();
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
}

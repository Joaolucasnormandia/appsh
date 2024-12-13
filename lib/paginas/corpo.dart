import 'package:appsh/listaralimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Corpo extends StatefulWidget {
  @override
  _CorpoState createState() => _CorpoState();
}

class _CorpoState extends State<Corpo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<FlSpot> _dataGrafico = [];
  double _totalCaloriasDiarias = 0;
  Map<String, double> _caloriasPorAlimento = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado')),
      );
      return;
    }

    final userId = user.uid;
    final dataAtual = DateTime.now();
    final inicioDoDia = DateTime(dataAtual.year, dataAtual.month, dataAtual.day);
    final fimDoDia = inicioDoDia.add(Duration(days: 1));

    try {
      final consumosSnapshot = await _firestore
          .collection('consumos')
          .where('uid_usuario', isEqualTo: userId)
          .where('data_consumo', isGreaterThanOrEqualTo: inicioDoDia)
          .where('data_consumo', isLessThan: fimDoDia)
          .get();

      Map<int, double> caloriasPorHora = {};
      double totalCalorias = 0;
      Map<String, double> caloriasPorAlimento = {};

      // Coleta de todos os documentos de alimentos consumidos de forma assíncrona
      List<Future<void>> foodFutures = [];
      for (var doc in consumosSnapshot.docs) {
        final uidAlimento = doc['uid_alimento'];

        foodFutures.add(
          _firestore.collection('foods').doc(uidAlimento).get().then((alimentoSnapshot) {
            if (alimentoSnapshot.exists) {
              final alimento = alimentoSnapshot.data()!;
              final calorias = alimento['calorias'] ?? 0;
              final nome = alimento['nome'] ?? 'Alimento';
              final dataConsumo = (doc['data_consumo'] as Timestamp).toDate();
              final hora = dataConsumo.hour;

              // Atualiza as calorias por hora e por alimento
              caloriasPorHora[hora] = (caloriasPorHora[hora] ?? 0) + calorias.toDouble();
              caloriasPorAlimento[nome] = (caloriasPorAlimento[nome] ?? 0) + calorias.toDouble();
              totalCalorias += calorias.toDouble();
            }
          }),
        );
      }

      // Aguarda todas as requisições serem concluídas antes de atualizar a UI
      await Future.wait(foodFutures);

      final spots = caloriasPorHora.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList();

      setState(() {
        _dataGrafico = spots;
        _totalCaloriasDiarias = totalCalorias;
        _caloriasPorAlimento = caloriasPorAlimento;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gráfico de Calorias')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _dataGrafico.isEmpty
                      ? Center(child: Text('Sem dados para exibir.'))
                      : LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) =>
                                      Text('${value.toInt()}h'),
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) =>
                                      Text('${value.toInt()} cal'),
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: _dataGrafico,
                                isCurved: true,
                                barWidth: 4,
                                color: Colors.blue,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            borderData: FlBorderData(show: true),
                            gridData: FlGridData(show: true),
                          ),
                        ),
                  SizedBox(height: 20),
                  Text(
                    'Total de calorias consumidas hoje: ${_totalCaloriasDiarias.toStringAsFixed(2)} cal',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Detalhes do consumo:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _caloriasPorAlimento.keys.length,
                      itemBuilder: (context, index) {
                        final nome = _caloriasPorAlimento.keys.elementAt(index);
                        final calorias = _caloriasPorAlimento[nome]!;

                        return ListTile(
                          title: Text(nome),
                          subtitle: Text('${calorias.toStringAsFixed(2)} cal'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) => ListarAlimentosScreen()),
          );
        },
        child: Text('Registrar Consumo'),
      ),
    );
  }
}

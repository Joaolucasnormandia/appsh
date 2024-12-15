import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListarAlimentosScreen extends StatefulWidget {
  const ListarAlimentosScreen({super.key});

  @override
  _ListarAlimentosScreenState createState() => _ListarAlimentosScreenState();
}

class _ListarAlimentosScreenState extends State<ListarAlimentosScreen> {
  String categoriaSelecionada = "Comida";
  double caloriasTotais = 0;

  @override
  void initState() {
    super.initState();
    _carregarCaloriasTotais();
  }

  Future<void> _carregarCaloriasTotais() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final userId = user.uid;
    final dataAtual = DateTime.now();
    final dataInicioDia =
        DateTime(dataAtual.year, dataAtual.month, dataAtual.day);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('consumos')
          .where('uid_usuario', isEqualTo: userId)
          .where('data_consumo', isGreaterThanOrEqualTo: dataInicioDia)
          .get();

      double calorias = 0;
      for (var doc in snapshot.docs) {
        final consumo = doc.data();
        calorias += consumo['calorias'] ?? 0;
      }

      setState(() {
        caloriasTotais = calorias;
      });
    } catch (e) {
      print('Erro ao carregar calorias totais: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categoria: $categoriaSelecionada'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                categoriaSelecionada = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return ['Comida', 'Bebida'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('foods')
                .where('categoria', isEqualTo: categoriaSelecionada)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Nenhum alimento encontrado.'));
              }

              final alimentos = snapshot.data!.docs;

              return Expanded(
                child: ListView.builder(
                  itemCount: alimentos.length,
                  itemBuilder: (context, index) {
                    final alimento =
                        alimentos[index].data() as Map<String, dynamic>;
                    final uid = alimentos[index].id;
                    final nome = alimento['nome'] ?? 'Sem Nome';
                    final calorias = alimento['calorias'] != null
                        ? alimento['calorias'].toDouble()
                        : 0;
                    final imagemUrl = alimento['imagemUrl'] ??
                        'https://via.placeholder.com/150';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(imagemUrl),
                      ),
                      title: Text(nome),
                      subtitle: Text('${calorias.toString()} calorias'),
                      trailing: IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _adicionarConsumo(uid, calorias);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Calorias Totais do Dia: $caloriasTotais kcal',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _adicionarConsumo(String uidAlimento, double calorias) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado.')),
      );
      return;
    }

    final userId = user.uid;
    final dataAtual = DateTime.now();

    try {
      await FirebaseFirestore.instance.collection('consumos').add({
        'uid_usuario': userId,
        'uid_alimento': uidAlimento,
        'data_consumo': dataAtual,
        'calorias': calorias,
      });
      setState(() {
        caloriasTotais += calorias;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.green),
                  const SizedBox(height: 20),
                  const Text(
                    'Consumo registrado com sucesso!',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar consumo: $e')),
      );
    }
  }
}

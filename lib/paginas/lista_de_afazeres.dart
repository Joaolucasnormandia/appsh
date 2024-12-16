import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Lista_Tarefa {
  String tarefa;
  bool concluida;
  DateTime creationTime;

  Lista_Tarefa({
    required this.tarefa,
    this.concluida = false,
  }) : creationTime = DateTime.now();

  // Converte a tarefa para um mapa para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'tarefa': tarefa,
      'concluida': concluida,
      'creationTime': creationTime,
    };
  }

  // Converte um documento Firestore para Lista_Tarefa
  factory Lista_Tarefa.fromMap(Map<String, dynamic> map) {
    return Lista_Tarefa(
      tarefa: map['tarefa'] ?? '',
      concluida: map['concluida'] ?? false,
    );
  }
}

class Minhas_Tarefas extends StatefulWidget {
  @override
  _Minhas_TarefasState createState() => _Minhas_TarefasState();
}

class _Minhas_TarefasState extends State<Minhas_Tarefas> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Lista_Tarefa> _toDoList = [];

  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
    _loadTarefas();
  }

  Future<void> _getUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    } else {
      print('Usuário não autenticado.');
    }
  }

  // Carregar tarefas do Firestore
  Future<void> _loadTarefas() async {
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('tarefas')
        .doc(userId)
        .collection('minhas_tarefas')
        .orderBy('creationTime', descending: true)
        .get();

    setState(() {
      _toDoList = snapshot.docs
          .map((doc) => Lista_Tarefa.fromMap(doc.data()))
          .toList();
    });
  }

  // Salvar tarefa no Firestore
  Future<void> _adicionarTarefa() async {
    if (_controller.text.isEmpty || userId == null) return;

    final tarefa = Lista_Tarefa(tarefa: _controller.text.trim());

    // Adicionar a tarefa no Firestore
    await _firestore
        .collection('tarefas')
        .doc(userId)
        .collection('minhas_tarefas')
        .add(tarefa.toMap());

    setState(() {
      _toDoList.add(tarefa);
    });

    _controller.clear();
  }

  // Alternar conclusão da tarefa
  Future<void> _alternarConclusaoTarefa(int indice) async {
    final tarefa = _toDoList[indice];
    tarefa.concluida = !tarefa.concluida;

    // Atualizar a tarefa no Firestore
    final querySnapshot = await _firestore
        .collection('tarefas')
        .doc(userId)
        .collection('minhas_tarefas')
        .where('tarefa', isEqualTo: tarefa.tarefa)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      await _firestore
          .collection('tarefas')
          .doc(userId)
          .collection('minhas_tarefas')
          .doc(docId)
          .update({'concluida': tarefa.concluida});
    }

    setState(() {
      _toDoList[indice] = tarefa;
    });
  }

  // Remover tarefa
  Future<void> _removerTarefa(int indice) async {
    final tarefa = _toDoList[indice];

    // Remover a tarefa do Firestore
    final querySnapshot = await _firestore
        .collection('tarefas')
        .doc(userId)
        .collection('minhas_tarefas')
        .where('tarefa', isEqualTo: tarefa.tarefa)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs[0].id;
      await _firestore
          .collection('tarefas')
          .doc(userId)
          .collection('minhas_tarefas')
          .doc(docId)
          .delete();
    }

    setState(() {
      _toDoList.removeAt(indice);
    });
  }

  // Limpar todas as tarefas
  Future<void> _limparTodasTarefas() async {
    if (userId == null) return;

    // Limpar todas as tarefas do Firestore
    final snapshot = await _firestore
        .collection('tarefas')
        .doc(userId)
        .collection('minhas_tarefas')
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    setState(() {
      _toDoList.clear();
    });
  }

  // Marcar todas as tarefas como concluídas
  Future<void> _marcarTodasComoConcluidas() async {
    if (userId == null) return;

    for (var tarefa in _toDoList) {
      tarefa.concluida = true;

      // Atualizar cada tarefa no Firestore
      final querySnapshot = await _firestore
          .collection('tarefas')
          .doc(userId)
          .collection('minhas_tarefas')
          .where('tarefa', isEqualTo: tarefa.tarefa)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs[0].id;
        await _firestore
            .collection('tarefas')
            .doc(userId)
            .collection('minhas_tarefas')
            .doc(docId)
            .update({'concluida': tarefa.concluida});
      }
    }

    setState(() {
      final snackBar = SnackBar(content: Text('Todas as tarefas foram concluídas!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  String _formatarTempoRestante(DateTime creationTime) {
    final expirationTime = creationTime.add(Duration(hours: 24));
    final remainingDuration = expirationTime.difference(DateTime.now());

    if (remainingDuration.isNegative) {
      return "Expirado";
    }

    final horas = remainingDuration.inHours;
    final minutos = remainingDuration.inMinutes % 60;
    final segundos = remainingDuration.inSeconds % 60;
    return "$horas h ${minutos.toString().padLeft(2, '0')} min ${segundos.toString().padLeft(2, '0')} s restantes";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text('Minhas Tarefas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Voltar',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: _marcarTodasComoConcluidas,
            tooltip: 'Marcar todas como concluídas',
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: _limparTodasTarefas,
            tooltip: 'Excluir todas as tarefas',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 2, 167, 148),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Informe sua tarefa',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _adicionarTarefa,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Cor do fundo do botão
                  textStyle: TextStyle(fontSize: 16), // Estilo do texto
                ),
                child: Text('Adicionar Tarefa'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    final item = _toDoList[index];
                    return ListTile(
                      title: Text(
                        item.tarefa,
                        style: TextStyle(
                          decoration: item.concluida
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: item.concluida
                          ? Text('Tarefa Concluída')
                          : Text(_formatarTempoRestante(item.creationTime)),
                      leading: Checkbox(
                        value: item.concluida,
                        onChanged: (_) => _alternarConclusaoTarefa(index),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removerTarefa(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

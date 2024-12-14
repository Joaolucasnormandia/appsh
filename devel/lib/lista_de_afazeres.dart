import 'package:flutter/material.dart';
import 'dart:async';

class Lista_Tarefa {
  String tarefa;
  bool concluida;
  DateTime creationTime;

  Lista_Tarefa({
    required this.tarefa,
    this.concluida = false,
  }) : creationTime = DateTime.now();
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Afazeres',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Minhas_Tarefas(),
    );
  }
}

class Minhas_Tarefas extends StatefulWidget {
  @override
  _Minhas_TarefasState createState() => _Minhas_TarefasState();
}

class _Minhas_TarefasState extends State<Minhas_Tarefas> {
  final List<Lista_Tarefa> _toDoList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _adicionarTarefa() {
    if (_controller.text.isEmpty) return;

    setState(() {
      final tarefa = Lista_Tarefa(tarefa: _controller.text.trim());
      _toDoList.add(tarefa);
    });

    _controller.clear();
  }

  void _alternarConclusaoTarefa(int indice) {
    setState(() {
      _toDoList[indice].concluida = !_toDoList[indice].concluida;
    });
  }

  void _removerTarefa(int indice) {
    setState(() {
      _toDoList.removeAt(indice);
    });
  }

  void _limparTodasTarefas() {
    setState(() {
      _toDoList.clear();
    });
  }

  void _marcarTodasComoConcluidas() {
    setState(() {
      for (var tarefa in _toDoList) {
        tarefa.concluida = true;
      }
    });

    if (_toDoList.isNotEmpty) {
      final snackBar = SnackBar(
          content: Text(
              'Parabéns! Você concluiu todas as tarefas, sua saúde só melhora.'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
        backgroundColor: const Color.fromARGB(255, 237, 237, 237),
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
              Colors.white,
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

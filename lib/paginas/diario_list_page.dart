import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Importação correta do pacote
import 'diario_form_page.dart';

class DiarioListPage extends StatefulWidget {
  @override
  _DiarioListPageState createState() => _DiarioListPageState();
}

class _DiarioListPageState extends State<DiarioListPage> {
  List<String> dias = ['Dia 1', 'Dia 2', 'Dia 3', 'Dia 4', 'Dia 5'];
  List<String> diasFiltrados = []; 
  Map<String, String> anotacoes = {};

  @override
  void initState() {
    super.initState();
    diasFiltrados = dias; 
    _loadData(); 
  }
  void _loadData() async {
    final prefs = await SharedPreferences.getInstance(); // Use SharedPreferences.getInstance()
    Map<String, String> newAnotacoes = {};

    for (var dia in dias) {
      String? savedHumor = prefs.getString('humor_$dia'); // Obtendo o valor corretamente
      newAnotacoes[dia] = savedHumor ?? 'Sem anotações';
    }

    setState(() {
      anotacoes = newAnotacoes;
    });
  }

  void _filtrarDias(String query) {
    setState(() {
      diasFiltrados = dias.where((dia) {
        final anotacao = anotacoes[dia]?.toLowerCase() ?? '';
        return dia.toLowerCase().contains(query.toLowerCase()) ||
               anotacao.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _removerRegistro(String dia) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('humor_$dia');
    await prefs.remove('atividades_$dia');
    await prefs.remove('alimentacao_$dia');
    await prefs.remove('notas_$dia');
    await prefs.remove('agua_$dia'); 

    setState(() {
      dias.remove(dia); 
      diasFiltrados = dias; 
      anotacoes.remove(dia); 
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro "$dia" removido com sucesso.')),
    );
  }

  void _adicionarNovoDia() {
    setState(() {
      int novoDia = dias.isNotEmpty ? dias.length + 1 : 1; 
      String novoDiaStr = 'Dia $novoDia';
      dias.add(novoDiaStr); 
      diasFiltrados = dias; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meu Diário',
          style: TextStyle(
            color: Colors.white, 
            fontSize: 22, 
            fontWeight: FontWeight.w600, 
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 4, 
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filtrarDias,
              decoration: InputDecoration(
                labelText: 'Pesquisar...',
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20), 
                  borderSide: BorderSide(color: Colors.black26), 
                ),
                filled: true, 
                fillColor: Colors.white, 
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: diasFiltrados.length,
              itemBuilder: (context, index) {
                final dia = diasFiltrados[index];
                return Card(
                  margin: EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), 
                  ),
                  elevation: 5, 
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      child: Icon(Icons.calendar_today, color: const Color.fromARGB(255, 255, 245, 233)),
                    ),
                    title: Text(
                      dia,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    subtitle: Text(
                      anotacoes[dia] ?? 'Sem anotações',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerRegistro(dia),
                    ),
                    onTap: () async {
                      final bool? updated = await Navigator.push<bool>(context,
                        MaterialPageRoute(
                          builder: (context) => DiarioFormPage(
                            dia: dia,
                            anotacaoExistente: anotacoes[dia],
                          ),
                        ),
                      );
                      if (updated == true) {
                        _loadData();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: Icon(
          Icons.add,
          color: const Color.fromARGB(255, 255, 245, 233),
        ),
        onPressed: () async {
          _adicionarNovoDia();
          final bool? updated = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => DiarioFormPage(
                dia: 'Dia ${dias.length}',
                anotacaoExistente: null,
              ),
            ),
          );
          if (updated == true) {
            _loadData(); 
          }
        },
      ),
    );
  }
}

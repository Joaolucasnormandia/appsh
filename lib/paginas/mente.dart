import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appsh/paginas/diario_list_page.dart';
import 'package:appsh/paginas/listaEmoji.dart';
import 'package:appsh/paginas/lista_de_afazeres.dart';

class Mente extends StatefulWidget {
  const Mente({super.key});

  @override
  State<Mente> createState() => _MenteState();
}

class _MenteState extends State<Mente> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserId();
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

  Future<void> _navigateDiario() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiarioListPage(),
      ),
    );
  }

  Future<void> _navigateTarefas() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Minhas_Tarefas(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1E2952) : const Color.fromARGB(255, 252, 241, 232),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? const Color(0xFF1E2952) : Colors.teal,
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text(
              'Mente',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: isDarkMode ? const Color(0xFF1E2952) : const Color.fromARGB(255, 252, 241, 232),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Como vai a cabeça hoje?",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20),
                    // Container verde: Exibe os 5 últimos emojis selecionados
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmojiHistory(),
                          ),
                        );
                      },
                      child: userId == null
                          ? Container(
                              width: 350.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: const Center(
                                child: Text(
                                  "Carregando emojis...",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('emojiHistory')
                                  .doc(userId)
                                  .collection('selections')
                                  .orderBy('timestamp', descending: true)
                                  .limit(5)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container(
                                    width: 350.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(color: Colors.white),
                                    ),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Container(
                                    width: 350.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Erro ao carregar emojis.",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  );
                                }

                                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                  return Container(
                                    width: 350.0,
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(40.0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Nenhum emoji recente.",
                                        style: TextStyle(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  );
                                }

                                final emojis = snapshot.data!.docs;
                                final reversedEmojis = List.from(emojis.reversed);

                                return Container(
                                  width: 350.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: reversedEmojis.length,
                                        itemBuilder: (context, index) {
                                          var emoji = reversedEmojis[index];
                                          int emojiId = emoji['emojiId'] ?? 0;
                                          String emojiPath = _getEmojiPath(emojiId);

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Image.asset(
                                              emojiPath,
                                              width: 50,
                                              height: 50,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 20),
                    // Alteração: Row para posicionar os botões lado a lado
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botão para Diário
                        GestureDetector(
                          onTap: _navigateDiario,
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6D4C99),
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/diario.png', 
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Botão para Tarefas
                        GestureDetector(
                          onTap: _navigateTarefas,
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(15.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/icons/anotacoes.png', // Substitua com o asset desejado
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEmojiPath(int emojiId) {
    final Map<int, String> emojiPaths = {
      1: 'assets/icons/calmo.png',
      2: 'assets/icons/devastado.png',
      3: 'assets/icons/feliz.png',
      4: 'assets/icons/felizao.png',
      5: 'assets/icons/felizin.png',
      6: 'assets/icons/neutro.png',
      7: 'assets/icons/preocupado.png',
      8: 'assets/icons/raiva.png',
      9: 'assets/icons/tristao.png',
    };

    return emojiPaths[emojiId] ?? 'assets/icons/neutro.png';
  }
}

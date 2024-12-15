import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa o pacote para autenticação
import 'package:appsh/paginas/emoji.dart'; // Verifique se o caminho da importação está correto

class EmojiHistory extends StatefulWidget {
  const EmojiHistory({super.key});

  @override
  State<EmojiHistory> createState() => _EmojiHistoryState();
}

class _EmojiHistoryState extends State<EmojiHistory> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instância do FirebaseAuth
  String? userId;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Obtém o UID do usuário autenticado ao inicializar
  }

  Future<void> _getUserId() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid; // Salva o UID do usuário autenticado
      });
    } else {
      print('Usuário não autenticado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Emojis"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userId == null
            ? const Center(
                child: Text("Por favor, faça login para visualizar seu histórico."),
              )
            : Column(
                children: [
                  // StreamBuilder para exibir o histórico de emojis do usuário
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('emojiHistory')
                          .doc(userId) // Documento do usuário
                          .collection('selections') // Subcoleção específica do usuário
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("Nenhum emoji selecionado."));
                        }

                        var emojis = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: emojis.length,
                          itemBuilder: (context, index) {
                            var emoji = emojis[index];

                            // Verificar se o 'emojiId' existe e é válido
                            int emojiId = emoji['emojiId'] ?? 0; // Caso o emojiId não exista ou seja nulo, usa 0

                            // Verificar se o 'timestamp' existe e é válido
                            String timestamp = '';
                            var emojiTimestamp = emoji['timestamp'];
                            if (emojiTimestamp != null && emojiTimestamp is Timestamp) {
                              timestamp = emojiTimestamp.toDate().toString();
                            } else {
                              timestamp = 'Data não disponível'; // Caso o timestamp seja nulo ou inválido
                            }

                            // Mapeamento dos emojis para exibição
                            String emojiPath = _getEmojiPath(emojiId);

                            return ListTile(
                              leading: Image.asset(emojiPath, width: 40, height: 40),
                              title: Text("Emoji $emojiId"),
                              subtitle: Text("Selecionado em: $timestamp"),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Botão para navegar até a página de seleção de emojis
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Emoji(), // Certifique-se de que ListaEmojiPage é uma página válida
                            ),
                          );
                        } catch (e) {
                          // Em caso de erro ao navegar, exibimos uma mensagem de erro
                          print("Erro ao navegar para a página de emojis: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Erro ao navegar para a página de emojis.")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
                      ),
                      child: const Text("Selecionar Emoji"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Mapeamento do ID para o caminho do emoji
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

    return emojiPaths[emojiId] ?? 'assets/icons/neutro.png'; // Retorna um caminho padrão se o ID não for encontrado
  }
}

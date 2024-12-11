import 'package:flutter/material.dart';
import 'package:trabalho_final/paginas/emoji.dart';

class Mente extends StatefulWidget {
  const Mente({super.key});

  @override
  State<Mente> createState() => _MenteState();
}

class _MenteState extends State<Mente> {
  List<String> selectedEmojis = []; // Lista para armazenar os emojis selecionados
  final int maxEmojis = 5; // Limite de emojis permitidos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Mente",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Como vai a cabeça hoje?",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 350.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9FD3C7),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Stack(
                      children: [
                        // Mostra os emojis selecionados com a cor preta
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedEmojis.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black, // Aplica a cor preta
                                  BlendMode.srcIn, // Substitui a cor original
                                ),
                                child: Image.asset(
                                  selectedEmojis[index],
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            );
                          },
                        ),
                        // Botão de adicionar emoji
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: ElevatedButton(
                            onPressed: () async {
                              // Navega para a página de seleção de emoji
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Emoji(),
                                ),
                              );
                              if (result != null && result is String) {
                                setState(() {
                                  // Se atingiu o limite, remove o primeiro emoji
                                  if (selectedEmojis.length >= maxEmojis) {
                                    selectedEmojis.removeAt(0);
                                  }
                                  // Adiciona o novo emoji
                                  selectedEmojis.add(result);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 123, 161, 152),
                              shape: CircleBorder(), // Torna o botão circular
                              padding: EdgeInsets.all(20),
                            ),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

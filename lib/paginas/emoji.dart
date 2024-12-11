import 'package:flutter/material.dart';

class Emoji extends StatefulWidget {
  const Emoji({super.key});

  @override
  State<Emoji> createState() => _EmojiState();
}

class _EmojiState extends State<Emoji> {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> emojis = {
      'Calmo': 'lib/icones/calmo.png',
      'Devastado': 'lib/icones/capitalismo.png',
      'Feliz': 'lib/icones/feliz.png',
      'Muito feliz': 'lib/icones/felizao.png',
      'Um pouco feliz': 'lib/icones/felizin.png',
      'Neutro': 'lib/icones/neutro.png',
      'Preocupado': 'lib/icones/preocupado.png',
      'Chateado': 'lib/icones/raiva.png',
      'Triste': 'lib/icones/tristao.png',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione um Emoji"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Número de colunas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            // Obtém o nome e caminho do emoji
            String key = emojis.keys.elementAt(index);
            String path = emojis[key]!;

            return GestureDetector(
              onTap: () {
                // Retorna o emoji selecionado ao voltar para a página anterior
                Navigator.pop(context, path);
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, // Aplica a cor preta
                  BlendMode.srcIn, // Substitui a cor original
                ),
                child: Column(
                  children: [
                    Image.asset(
                      path,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      key,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

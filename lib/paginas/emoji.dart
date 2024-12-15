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
      'Calmo': 'assets/icons/calmo.png',
      'Devastado': 'assets/icons/devastado.png',
      'Feliz': 'assets/icons/feliz.png',
      'Muito feliz': 'assets/icons/felizao.png',
      'Um pouco feliz': 'assets/icons/felizin.png',
      'Neutro': 'assets/icons/neutro.png',
      'Preocupado': 'assets/icons/preocupado.png',
      'Chateado': 'assets/icons/raiva.png',
      'Triste': 'assets/icons/tristao.png',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecione um Emoji"),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            String key = emojis.keys.elementAt(index);
            String path = emojis[key]!;
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, path);
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary, 
                  BlendMode.srcIn, 
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

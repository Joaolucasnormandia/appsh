import 'package:appsh/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigPage extends StatelessWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configurações",
          style: TextStyle(color: const Color(0xFFFDF6E3)),
        ),
        backgroundColor: const Color(0xFF1E2952),
      ),
      backgroundColor: const Color(0xFF1E2952),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Modo Escuro",
              style: TextStyle(
                color: const Color(0xFFFDF6E3),
                fontSize: 18,
              ),
            ),
            Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
              activeColor: Colors.white,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }
}


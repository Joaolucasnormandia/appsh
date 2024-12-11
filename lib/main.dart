import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trabalho_final/paginas/navegation.dart';
import 'package:trabalho_final/paginas/tema.dart/tema.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Navegation(),
      theme: modoClaro,
      darkTheme: modoEscuro,
      themeMode: themeProvider.themeMode, // Controla o tema com o provider
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

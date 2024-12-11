import 'package:appsh/paginas/login/telalogin.dart';
import 'package:appsh/paginas/tema.dart/tema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  
  
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();  

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
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
      home: TelaLogin(),
      theme: modoClaro,
      darkTheme: modoEscuro,
      themeMode: themeProvider.themeMode, 
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;


  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false; 
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }


  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);

    notifyListeners();
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveData(String userId, Map<String, dynamic> data) async {
    try {
      await _db.collection('users').doc(userId).set(data);
    } on FirebaseException catch (e) {
      print("Erro ao salvar dados: ${e.message}");
    }
  }

  Future<Map<String, dynamic>?> getData(String userId) async {
    try {
      DocumentSnapshot snapshot = await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print("Erro ao recuperar dados: ${e.message}");
      return null;
    }
  }
}

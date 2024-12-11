import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diário de Saúde',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade200,
              Colors.white,
            ],
          ),
          border: Border.all(
            color: const Color.fromARGB(255, 2, 167, 148),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/tbt.png',
                height: 300,
              ),
              SizedBox(height: 30),
              Text(
                'Bem-vindo ao Happy Saúde!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Acompanhe seus sintomas, '
                  'monitore seu bem-estar e crie hábitos saudáveis de maneira simples e eficaz.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 1, 169, 150),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.health_and_safety, color: Colors.teal, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Registre seus sintomas diários',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.track_changes, color: Colors.teal, size: 30),
                  SizedBox(width: 10),
                  Text(
                    'Monitore seu progresso',
                    style: TextStyle(fontSize: 16, color: Colors.teal),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 
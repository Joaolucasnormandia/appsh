import 'package:appsh/paginas/WelcomeScreen.dart';
import 'package:appsh/paginas/config.dart';
import 'package:appsh/paginas/corpo.dart';
import 'package:appsh/paginas/mente.dart';
import 'package:appsh/paginas/perfil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class Navegation extends StatefulWidget {
  Navegation({super.key});

  @override
  State<Navegation> createState() => _NavegationState();
}

class _NavegationState extends State<Navegation> {
  int _pag_selecionada = 1;

  void _NavigationBarCurved(int index) {
    setState(() {
      _pag_selecionada = index;
    });
  }

  final List _paginas = [
    // mente
    Mente(),
    // perfil
    Perfil(),
    // corpo
    Corpo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Navegação'),
        backgroundColor: Colors.teal,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/tbt.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Happy Saúde',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                // Adicione a ação para navegar para a tela inicial se necessário
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _pag_selecionada = 1; // Altera para a tela de Perfil
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text('Corpo'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _pag_selecionada = 2; // Altera para a tela de Corpo
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConfigPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
      body: _paginas[_pag_selecionada],
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        color: Colors.black,
        onTap: _NavigationBarCurved,
        index: _pag_selecionada,
        items: [
          Container(
            color: Colors.black,
            child: Image.asset(
              'assets/icons/cerebro.png',
              color: const Color.fromARGB(255, 255, 245, 233),
            ),
            height: 30,
          ),
          const Icon(
            Icons.person,
            color: Color.fromARGB(255, 255, 245, 233),
            size: 30,
          ),
          const Icon(
            Icons.fitness_center,
            color: Color.fromARGB(255, 255, 245, 233),
            size: 30,
          ),
        ],
      ),
    );
  }
}

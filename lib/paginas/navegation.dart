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
      body: _paginas[_pag_selecionada], 
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:  Theme.of(context).colorScheme.background,
        color: Colors.black,
        onTap: _NavigationBarCurved, 
        index: _pag_selecionada, 
        items: [
          // mente
          Container(
            color: Colors.black,
            child: Image.asset(
              'lib/icones/cerebro.png',
              color: const Color.fromARGB(255, 255, 245, 233),
            ),
            height: 30,
          ),
          // Perfil
          Icon(
            Icons.person,
            color: const Color.fromARGB(255, 255, 245, 233),
            size: 30,
          ),
          // corpo
          Icon(
            Icons.fitness_center,
            color: const Color.fromARGB(255, 255, 245, 233),
            size: 30,
          ),
        ],
      ),
    );
  }
}

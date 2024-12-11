import 'package:flutter/material.dart';

class Corpo extends StatefulWidget {
  const Corpo({super.key});

  @override
  State<Corpo> createState() => _MenteState();
}

class _MenteState extends State<Corpo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Theme.of(context).colorScheme.background,
       appBar: AppBar(
        elevation: 1,
        backgroundColor:  Theme.of(context).colorScheme.background,
        title: Text(
          "Corpo",
          style: TextStyle(
            fontWeight: FontWeight.w800),
          ),
        centerTitle: true,
       ),
      body: Center(
        child: Text("corpo",),
      ),
    );
  }
}
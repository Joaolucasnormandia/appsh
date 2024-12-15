import 'package:appsh/paginas/cadagua.dart';
import 'package:flutter/material.dart';
import 'package:appsh/paginas/imc.dart';

class Corpo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkMode ? const Color(0xFF1E2952) : Colors.teal,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/iconetelasaude.gif',
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 10),
            const Text(
              'Saúde Física',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: isDarkMode ? const Color(0xFF1E2952) : const Color.fromARGB(255, 252, 241, 232),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                height: 320,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Botões de cálculo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cálculo',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2952),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => IMCApp()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Image.asset(
                            'assets/icons/imc.png',
                            height: 95,
                            width: 95,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CalcularAgua()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Image.asset(
                            'assets/icons/calcularagua.png',
                            height: 95,
                            width: 95,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // Divisor
                    Container(
                      width: 2,
                      height: 240,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 20),
                    // Imagem do copo tocável com textos
                    Column(
                      children: [
                        const SizedBox(height: 4), // Ajuste fino para alinhar os títulos
                        const Text(
                          'Consumo de Água',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2952),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // Insira aqui a ação que você quer ao pressionar este botão
                          },
                          child: Image.asset(
                            'assets/icons/iconecopo/copo0.png',
                            height: 150, // Ajuste o tamanho da imagem aqui
                            width: 150,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '0/2L',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

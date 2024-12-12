import 'dart:io';
import 'package:appsh/paginas/config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final image_piker = ImagePicker();
  File? image_file;

  pick(ImageSource source) async {
    final pickedFile = await image_piker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        image_file = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Perfil",
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfigPage()),
              );
            },
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: const Color(0xFF9FD3C7),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Theme.of(context).colorScheme.background,
                          backgroundImage: image_file != null
                              ? FileImage(image_file!)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF8F5FBF),
                          child: IconButton(
                            onPressed: _showOpcoesBottomSheet,
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFFFDF6E3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Placeholder",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFDF6E3),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                width: 350.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF8F5FBF),
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF9FD3C7),
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350.0,
                height: 80.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A59),
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showOpcoesBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF9FD3C7),
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: Color(0xFF1E2952),
                    ),
                  ),
                ),
                title: const Text(
                  'Galeria',
                  style: TextStyle(color: Color(0xFF1E2952)),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFF7A59),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: Color(0xFFFDF6E3),
                    ),
                  ),
                ),
                title: Text(
                  'Câmera',
                  style: TextStyle(color: const Color(0xFF1E2952)),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF8F5FBF),
                  child: Center(
                    child: Icon(
                      Icons.delete,
                      color: Color(0xFFFDF6E3),
                    ),
                  ),
                ),
                title: const Text(
                  'Remover',
                  style: TextStyle(color: Color(0xFF1E2952)),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    image_file = null;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

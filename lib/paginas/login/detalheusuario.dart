import 'package:appsh/paginas/navegation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetalheCadastroScreen extends StatefulWidget {
  final String uid;
  DetalheCadastroScreen({required this.uid});

  @override
  _DetalheCadastroScreenState createState() => _DetalheCadastroScreenState();
}

class _DetalheCadastroScreenState extends State<DetalheCadastroScreen> {
  final TextEditingController _apelidoController = TextEditingController(); // Usando controlador para apelido
  bool _isLoading = false;
  int _currentStep = 0;
  List<String> _sexos = ['Masculino', 'Feminino'];
  List<int> _dias = List.generate(31, (index) => index + 1);
  List<int> _meses = List.generate(12, (index) => index + 1);
  List<int> _anos = List.generate(100, (index) => DateTime.now().year - index);
  int _selectedDia = 1;
  int _selectedMes = 1;
  int _selectedAno = DateTime.now().year;
  String? _selectedSexo;

  Future<void> _saveApelido() async {
    if (_apelidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu apelido.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Depuração para garantir que o apelido está correto
      print("Salvando apelido: ${_apelidoController.text}");

      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'apelido': _apelidoController.text, // Salvando apelido no Firestore
      }, SetOptions(merge: true));

      // Confirmar que o apelido foi salvo com sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apelido salvo com sucesso!')),
      );
    } catch (e) {
      // Em caso de erro, exibir mensagem e logar o erro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o apelido.')),
      );
      print("Erro ao salvar apelido: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSexo(String sexo) async {
    if (sexo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira seu sexo.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'sexo': sexo,
      }, SetOptions(merge: true));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar o sexo.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveDataNascimento() async {
    String dataNascimento = '$_selectedDia/$_selectedMes/$_selectedAno';

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'dataNascimento': dataNascimento,
      }, SetOptions(merge: true));
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 20),
                  Text(
                    'Cadastrado com sucesso!',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      );
      await Future.delayed(const Duration(seconds: 5));
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Navegation()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar a data de nascimento.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Salvar apelido quando avançar para a próxima etapa
      _saveApelido();
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _saveDataNascimento();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Detalhes')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 3,
              backgroundColor: Colors.grey[200],
              color: Colors.teal,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _nextStep,
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep--;
                    });
                  }
                },
                steps: [
                  Step(
                    title: Text('Apelido'),
                    content: TextFormField(
                      controller: _apelidoController, // Usando o controlador para apelido
                      decoration: InputDecoration(
                        labelText: 'Apelido',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 0,
                    state: _currentStep == 0 ? StepState.editing : StepState.complete,
                  ),
                  Step(
                    title: Text('Gênero'),
                    content: Column(
                      children: [
                        const Text(
                          'Selecione seu Gênero:',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<String>(
                          value: _selectedSexo,
                          hint: Text('Selecione o Gênero'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSexo = newValue;
                            });
                            if (newValue != null) {
                              _saveSexo(newValue);
                            }
                          },
                          items: _sexos.map<DropdownMenuItem<String>>((String sexo) {
                            return DropdownMenuItem<String>(
                              value: sexo,
                              child: Text(sexo),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 1,
                    state: _currentStep == 1 ? StepState.editing : StepState.complete,
                  ),
                  Step(
                    title: Text('Data de Nascimento'),
                    content: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPicker(
                              _dias,
                              _selectedDia,
                              (value) => setState(() {
                                _selectedDia = value;
                              }),
                            ),
                            _buildPicker(
                              _meses,
                              _selectedMes,
                              (value) => setState(() {
                                _selectedMes = value;
                              }),
                            ),
                            _buildPicker(
                              _anos,
                              _selectedAno,
                              (value) => setState(() {
                                _selectedAno = value;
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                    isActive: _currentStep >= 2,
                    state: _currentStep == 2 ? StepState.editing : StepState.complete,
                  ),
                ],
              ),
            ),
            if (_isLoading) ...[
              const SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.green),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPicker(
      List<int> values, int selectedValue, ValueChanged<int> onChanged) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 40,
        onSelectedItemChanged: (index) {
          onChanged(values[index]);
        },
        children: values.map((value) {
          return Center(child: Text(value.toString()));
        }).toList(),
        scrollController: FixedExtentScrollController(initialItem: values.indexOf(selectedValue)),
      ),
    );
  }
}

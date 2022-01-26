import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';

class MyFarm extends StatefulWidget {
  const MyFarm(Key? key) : super(key: key);

  @override
  State<MyFarm> createState() => _MyFarmState();
}

class _MyFarmState extends State<MyFarm> {
  _MyFarmState();

  final _formKey = GlobalKey<FormState>();
  late String _farmName, _farmAddress; // TODO: les inn fra db først
  String _feedback = '';
  bool _validationActivated = false;

  String? validateLength(String? input, String feedback) {
    if (input!.isEmpty) {
      return feedback;
    }
    return null;
  }

  void _saveFarm() {
    setState(() {
      _formKey.currentState!.save();
      _formKey.currentState!.validate();
      _validationActivated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 9,
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 95),
                      child: const Text('Gårdsnavn',
                          style: TextStyle(fontSize: 16)))),
              const Spacer(),
              Flexible(
                  flex: 8,
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextFormField(
                          key: const Key('inputFarmName'),
                          validator: (input) =>
                              validateLength(input, 'Skriv gårdsnavn'),
                          onSaved: (input) => _farmName = input.toString(),
                          onChanged: (text) {
                            setState(() {
                              _feedback = '';
                            });
                          },
                          onFieldSubmitted: (_) => _saveFarm(),
                          decoration:
                              customInputDecoration('Navn', Icons.badge)))),
            ],
          ),
          customFieldSpacing(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 9,
                  child: Container(
                      constraints: const BoxConstraints(minWidth: 95),
                      child: const Text('Gårdsadresse',
                          style: TextStyle(fontSize: 16)))),
              const Spacer(),
              Flexible(
                  flex: 8,
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextFormField(
                          key: const Key('inputFarmAddress'),
                          validator: (input) =>
                              validateLength(input, 'Skriv adresse'),
                          onSaved: (input) => _farmName = input.toString(),
                          onChanged: (text) {
                            if (_validationActivated) {
                              setState(() {
                                _feedback = '';
                              });
                            }
                          },
                          onFieldSubmitted: (_) => _saveFarm(),
                          decoration:
                              customInputDecoration('Adresse', Icons.badge)))),
            ],
          ),
          AnimatedOpacity(
            opacity: _validationActivated ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              _feedback,
              key: const Key('feedback'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
              key: const Key('saveFarmButton'),
              onPressed: _saveFarm,
              child: const Text(
                "Lagre",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 50),
              ))
        ]));
  }
}

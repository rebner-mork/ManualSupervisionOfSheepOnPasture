import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp(null));
}

class MyApp extends StatefulWidget {
  const MyApp(Key? key) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Material(
            child: Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 150), // TODO?
          TextFormField(
            autofocus: true,
            validator: (value) => validateUserName(value),
            decoration: const InputDecoration(
                hintText: 'Brukernavn', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          TextFormField(
            validator: (value) => validatePassword(value),
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'Passord', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                _formKey.currentState!.validate();
              },
              child: const Text('Logg inn'))
        ],
      ),
    )));
  }
}

String? validateUserName(String? userName) {
  if (userName!.isEmpty) {
    return 'Skriv brukernavn';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password!.isEmpty) {
    return 'Skriv passord';
  }
  return null;
}

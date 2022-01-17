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
  bool visiblePassword = false;

  void _toggleVisiblePassword() {
    setState(() {
      visiblePassword = !visiblePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Material(
            child: Form(
      key: _formKey,
      child: FractionallySizedBox(
        widthFactor: 0.6,
        child: Column(
          children: [
            const SizedBox(height: 120), // TODO?
            const Icon(
              Icons.account_circle,
              size: 80,
            ),
            const SizedBox(height: 20),
            TextFormField(
              textAlign: TextAlign.center,
              autofocus: true,
              validator: (value) => validateUserName(value),
              decoration: const InputDecoration(
                  hintText: 'Brukernavn', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              textAlign: TextAlign.center,
              validator: (value) => validatePassword(value),
              obscureText: visiblePassword,
              decoration: InputDecoration(
                  //contentPadding: EdgeInsets.fromLTRB(left, top, right, bottom),
                  // Align hinttext og synlig-ikon
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      highlightColor: Colors.black,
                      onPressed: _toggleVisiblePassword),
                  hintText: 'Passord',
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                },
                child: const Text('Logg inn')),
            const SizedBox(height: 300),
            ElevatedButton(
                onPressed: () {}, child: const Text('Registrer ny bruker'))
          ],
        ),
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

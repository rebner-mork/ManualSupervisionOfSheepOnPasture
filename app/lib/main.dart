import 'package:app/secondscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as logger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  late String _email, _password;

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
            const SizedBox(height: 120),
            const Icon(
              Icons.account_circle,
              size: 80,
            ),
            const SizedBox(height: 20),
            TextFormField(
              autofocus: true,
              validator: (input) => validateUserName(input),
              onSaved: (input) => _email = input.toString(),
              decoration: const InputDecoration(
                  labelText: 'Brukernavn',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (input) => validatePassword(input),
              onSaved: (input) => _password = input.toString(),
              obscureText: !visiblePassword,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                          visiblePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20),
                      color: !visiblePassword ? Colors.grey : Colors.blue,
                      onPressed: _toggleVisiblePassword),
                  labelText: 'Passord',
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: signIn,
                //_formKey.currentState!.validate();
                child: const Text('Logg inn')),
            const SizedBox(height: 300),
            ElevatedButton(
                onPressed: () {}, child: const Text('Registrer ny bruker'))
          ],
        ),
      ),
    )));
  }

  Future<void> signIn() async {
    // Future<User>?
    logger.log('Logger inn');
    //print(object)
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        logger.log("JA: " + user.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SecondScreen(
                    userCredential:
                        user))); //SecondScreen(user: FirebaseAuth.instance.currentUser)));
      } catch (e) {
        logger.log("NEI: " + e.toString());
      }
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
}

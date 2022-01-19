import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
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
  bool _visiblePassword = false;
  bool _loginFailed = false;
  late String _email, _password;

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
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
              validator: (input) => validateEmail(input),
              onSaved: (input) => _email = input.toString(),
              onChanged: (text) {
                if (_loginFailed) {
                  setState(() {
                    _loginFailed = false;
                  });
                }
              },
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) => signIn(),
              decoration: const InputDecoration(
                  labelText: 'E-post',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (input) => validatePassword(input),
              onSaved: (input) => _password = input.toString(),
              onChanged: (text) {
                if (_loginFailed) {
                  setState(() {
                    _loginFailed = false;
                  });
                }
              },
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) => signIn(),
              obscureText: !_visiblePassword,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(
                          _visiblePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20),
                      color: !_visiblePassword ? Colors.grey : Colors.blue,
                      onPressed: _toggleVisiblePassword),
                  labelText: 'Passord',
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _loginFailed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                _loginFailed ? 'E-post eller passord er ugyldig' : '',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(onPressed: signIn, child: const Text('Logg inn')),
            const SizedBox(height: 300),
            ElevatedButton(
                onPressed: () {}, child: const Text('Registrer ny bruker'))
          ],
        ),
      ),
    )));
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        logger.log("Innlogget som: " + user.toString());
      } catch (e) {
        logger.log("Ikke innlogget: " + e.toString());
        setState(() {
          _loginFailed = true;
        });
      }
    }
  }

  String? validateEmail(String? email) {
    if (email!.isEmpty) {
      return 'Skriv e-post';
    } else if (!EmailValidator.validate(email)) {
      return 'Skriv gyldig e-post';
    }
    return null;
  }

  String? validatePassword(String? password) {
    if (password!.isEmpty) {
      return 'Skriv passord';
    } else if (password.length < 8) {
      return 'Passord må inneholde minst 8 tegn';
    }

    return null;
  }
}

import 'dart:async';
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
  bool _visiblePassword = false;
  bool _loginFailed = false;
  late String _email, _password, _feedbackMessage;

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
              validator: (input) => validateMail(input),
              onSaved: (input) => _email = input.toString(),
              onChanged: (text) {
                if (_loginFailed) {
                  setState(() {
                    _loginFailed = false;
                  });
                }
              },
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
                (() {
                  if (_loginFailed) {
                    return _feedbackMessage;
                  } else {
                    return '';
                  }
                })(),
                style: TextStyle(backgroundColor: Colors.red.shade400),
              ),
            ),
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
        // TODO: bytt skjerm

      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          _feedbackMessage = 'E-post er ugyldig';
        } else {
          _feedbackMessage = 'E-post eller passord er ugyldig';
        }
        setState(() {
          _loginFailed = true;
        });
      } catch (e) {
        logger.log(e.toString());
        // TODO: Annen error
      }
    }
  }

  String? validateMail(String? mail) {
    if (mail!.isEmpty) {
      return 'Skriv e-post';
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

import 'package:app/utils/field_validation.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as logger;

class RegisterWidget extends StatefulWidget {
  const RegisterWidget(Key? key) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  _RegisterWidgetState();

  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = false;
  bool _registerFailed = false;
  late String _email, _password, _phone, _feedback;

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  final passwordOneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.account_circle,
                    size: 90, color: Colors.black54),
                customFieldSpacing(),
                TextFormField(
                    key: const Key('inputEmail'),
                    validator: (input) => validateEmail(input),
                    onSaved: (input) => _email = input.toString(),
                    onChanged: (text) {
                      if (_registerFailed) {
                        setState(() {
                          _registerFailed = false;
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => register(),
                    decoration: customInputDecoration('E-post', Icons.mail)),
                customFieldSpacing(),
                TextFormField(
                    controller: passwordOneController,
                    key: const Key('inputPasswordOne'),
                    validator: (input) => validatePassword(input),
                    onSaved: (input) => _password = input.toString(),
                    onChanged: (text) {
                      if (_registerFailed) {
                        setState(() {
                          _registerFailed = false;
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => register(),
                    obscureText: !_visiblePassword,
                    decoration: customInputDecoration('Passord', Icons.lock,
                        passwordField: true,
                        isVisible: _visiblePassword,
                        onPressed: _toggleVisiblePassword)),
                customFieldSpacing(),
                TextFormField(
                    key: const Key('inputPasswordTwo'),
                    validator: (input) =>
                        passwordsAreEqual(passwordOneController.text, input),
                    onChanged: (text) {
                      if (_registerFailed) {
                        setState(() {
                          _registerFailed = false;
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => register(),
                    obscureText: !_visiblePassword,
                    decoration: customInputDecoration(
                        'Gjenta passord', Icons.lock,
                        passwordField: true,
                        isVisible: _visiblePassword,
                        onPressed: _toggleVisiblePassword)),
                customFieldSpacing(),
                TextFormField(
                    key: const Key('inputPhone'),
                    validator: (input) => validatePhone(input),
                    onSaved: (input) => _phone = input.toString(),
                    onChanged: (text) {
                      if (_registerFailed) {
                        setState(() {
                          _registerFailed = false;
                        });
                      }
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => register(),
                    decoration: customInputDecoration('Telefon', Icons.phone)),
                customFieldSpacing(),
                AnimatedOpacity(
                  opacity: _registerFailed ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _registerFailed ? _feedback : '',
                    key: const Key('feedback'),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: register,
                    child: const Text('Opprett bruker',
                        style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 60)))
              ],
            )));
  }

  void register() async {
    final formState = _formKey.currentState;

    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        logger.log('Bruker registrert: ' + user.toString());

        CollectionReference users =
            FirebaseFirestore.instance.collection('users');

        await users
            .add({'email': _email, 'phone': _phone})
            .then((value) =>
                logger.log('Telefonnummer lagt til i users/' + value.id))
            .catchError((error) => logger.log('Feil: ' + error.toString()));

        setState(() {
          _registerFailed = false;
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            _feedback = 'E-posten er allerede i bruk';
            break;
          case 'invalid-email':
            _feedback = 'Skriv gyldig e-post';
            break;
          case 'weak-password':
            _feedback = 'Skriv sterkere passord';
            break;
        }
        setState(() {
          _registerFailed = true;
        });
      } catch (e) {
        _feedback = 'Kunne ikke opprette bruker';
        setState(() {
          _registerFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordOneController.dispose();
    super.dispose();
  }
}

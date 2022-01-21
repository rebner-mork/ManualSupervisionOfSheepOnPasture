import 'package:app/utils/authentication.dart';
import 'package:app/utils/customWidgets.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(Key? key) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  _RegisterState();

  final _formKey = GlobalKey<FormState>();
  bool _registerFailed = false;
  late String _email, _password, _phone;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.6,
        child: Column(
          children: [
            const Spacer(flex: 1),
            Flexible(
                flex: 18,
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Icon(Icons.account_circle,
                            size: 90, color: Colors.black54),
                        const SizedBox(height: 20),
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
                            decoration:
                                customInputDecoration('E-post', Icons.mail)),
                        const SizedBox(height: 20),
                        TextFormField(
                            key: const Key('inputPassword'),
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
                            decoration:
                                customInputDecoration('Passord', Icons.lock)),
                        const SizedBox(height: 20),
                        TextFormField(
                            key: const Key('inputPhone'),
                            validator: (input) => validatePassword(input),
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
                            decoration:
                                customInputDecoration('Telefon', Icons.phone)),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: _registerFailed ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _registerFailed
                                ? 'E-post eller passord er ugyldig'
                                : '',
                            key: const Key('feedback'),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: register,
                            child: const Text('Opprett bruker'),
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(180, 60)))
                      ],
                    )))
          ],
        ));
  }

  void register() {}
}

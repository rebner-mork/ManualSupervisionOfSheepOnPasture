import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/field_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as logger;

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  _LoginWidgetState();

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
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const Icon(
              Icons.account_circle,
              size: 90,
              color: Colors.black54,
            ),
            inputFieldSpacer(),
            TextFormField(
              key: const Key('inputEmail'),
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
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            inputFieldSpacer(),
            TextFormField(
              key: const Key('inputPassword'),
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
                  labelText: 'Passord',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                          _visiblePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20),
                      color: !_visiblePassword ? Colors.grey : Colors.green,
                      onPressed: _toggleVisiblePassword)),
            ),
            inputFieldSpacer(),
            AnimatedOpacity(
              opacity: _loginFailed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                _loginFailed ? 'E-post eller passord er ugyldig' : '',
                key: const Key('feedback'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              key: const Key('loginButton'),
              onPressed: signIn,
              child: const Text('Logg inn', style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(fixedSize: const Size(180, 60)),
            ),
          ],
        ));
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        logger.log("Innlogget som: " + user.toString());
        setState(() {
          _loginFailed = false;
        });
      } catch (e) {
        logger.log("Ikke innlogget: " + e.toString());
        setState(() {
          _loginFailed = true;
        });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:web/utils/authenticiation.dart' as authentication;
import 'package:email_validator/email_validator.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = true;
  String _email = '';
  String _password = '';
  String _loginMessage = '';
  bool _validationActivated = false;

  String? _validateUserName(String? userName) {
    if (userName!.isEmpty && _validationActivated) {
      return "Skriv inn e-post";
    } else if (!EmailValidator.validate(_email) && _validationActivated) {
      return "Skriv gyldig e-post";
    }
    return null;
  }

  String? _validatePassword(String? password) {
    int requiredLength = 8;
    if (password!.isEmpty && _validationActivated) {
      return "Skriv inn passord";
    } else if (_password.length < requiredLenght && _validationActivated) {
      return "Passord må inneholde minst $requiredLength tegn";
    }
    return null;
  }

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  Future<void> _logIn() async {
    String tmp = '';
    setState(() {
      _validationActivated = true;
    });
    if (_formKey.currentState!.validate()) {
      tmp = await authentication.signIn(_email, _password);
      if (_loginMessage.isEmpty) {
        //TODO Navigator.pushNamed(context, 'home_widget_something');
      }
      setState(() {
        _loginMessage = tmp;
      });
    }
  }

  void _onChangeEmail(String input) {
    setState(() {
      _email = input;
    });
    if (_validationActivated) {
      _formKey.currentState!.validate();
    }
  }

  void _onChangePassword(String input) {
    setState(() {
      _password = input;
    });
    if (_validationActivated) {
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          const Icon(
            Icons.account_circle,
            size: 200,
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            key: const Key('inputEmail'),
            autofocus: true,
            textAlign: TextAlign.left,
            validator: _validateUserName,
            onChanged: (text) {
              _onChangeEmail(text);
            },
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: "E-post",
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
              key: const Key('inputPassword'),
              textAlign: TextAlign.left,
              validator: _validatePassword,
              obscureText: _visiblePassword,
              onChanged: (text) {
                _onChangePassword(text);
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: "Passord",
                  suffixIcon: IconButton(
                      icon: Icon(_visiblePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: _toggleVisiblePassword,
                      color: _visiblePassword ? Colors.grey : Colors.green),
                  border: const OutlineInputBorder())),
          const SizedBox(
            height: 5,
          ),
          Text(
            _loginMessage,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {
              _logIn();
            },
            child: const Text("Logg inn"),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(300, 60),
              textStyle: const TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ),
        ]));
  }
}

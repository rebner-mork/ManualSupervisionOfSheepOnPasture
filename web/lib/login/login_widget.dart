import 'package:flutter/material.dart';
import 'package:web/utils/authenticiation.dart' as authentication;

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
  bool _failedAtLogin = false;

  String? _validateUserName(String? userName) {
    if (userName!.isEmpty && _failedAtLogin) {
      return "Skriv inn brukernavn";
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password!.isEmpty && _failedAtLogin) {
      return "Skriv inn passord";
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
    if (_formKey.currentState!.validate()) {
      tmp = await authentication.signIn(_email, _password);
      if (_loginMessage.isEmpty) {
        //TODO Navigator.pushNamed(context, 'home_widget_something');
      } else {
        _failedAtLogin = true;
      }
    } else {
      setState(() {
        _loginMessage = tmp;
      });
    }
  }

  void _onChangeEmail(String input) {
    setState(() {
      _email = input;
    });
    if (_failedAtLogin) {
      _formKey.currentState!.validate();
    }
  }

  void _onChangePassword(String input) {
    setState(() {
      _password = input;
    });
    if (_failedAtLogin) {
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          const Spacer(flex: 10),
          const Icon(
            Icons.account_circle,
            size: 200,
          ),
          const Spacer(flex: 2),
          Flexible(
              flex: 10,
              child: TextFormField(
                autofocus: true,
                textAlign: TextAlign.left,
                validator: _validateUserName,
                onChanged: (text) {
                  _onChangeEmail(text);
                },
                decoration: const InputDecoration(
                    hintText: "E-post", border: OutlineInputBorder()),
              )),
          const Spacer(),
          Flexible(
            flex: 10,
            child: TextFormField(
                textAlign: TextAlign.left,
                validator: _validatePassword,
                obscureText: _visiblePassword,
                onChanged: (text) {
                  _onChangePassword(text);
                },
                decoration: InputDecoration(
                    hintText: "Passord",
                    suffixIcon: IconButton(
                        icon: Icon(_visiblePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: _toggleVisiblePassword),
                    border: const OutlineInputBorder())),
          ),
          const Spacer(flex: 2),
          Flexible(
              child: Text(
            _loginMessage,
            style: const TextStyle(color: Colors.red),
          )),
          const Spacer(flex: 5),
          Flexible(
              flex: 10,
              child: ElevatedButton(
                onPressed: () {
                  _logIn();
                },
                child: const Text("Logg inn"),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 60),
                    textStyle: const TextStyle(fontSize: 30)),
              )),
          const Spacer(flex: 10),
          //TODO forgot password
          const Flexible(
              flex: 10,
              child: Text(
                "Om du ikker har en brukerkonto ennå, kan du oprette en her:",
              )),
          const Spacer(),
          Flexible(
              flex: 10,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'create_user');
                },
                child: const Text("Opprett brukerkonto"),
                style: ElevatedButton.styleFrom(fixedSize: const Size(200, 50)),
              ))
        ]));
  }
}

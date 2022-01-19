import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = true;

  String? _validateUserName(String? userName) {
    if (userName!.isEmpty) {
      return "Skriv inn brukernavn";
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password!.isEmpty) {
      return "Skriv inn passord";
    }
    return null;
  }

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
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
                decoration: const InputDecoration(
                    hintText: "Brukernavn", border: OutlineInputBorder()),
              )),
          const Spacer(),
          Flexible(
            flex: 10,
            child: TextFormField(
                textAlign: TextAlign.left,
                validator: _validatePassword,
                obscureText: _visiblePassword,
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
              flex: 10,
              child: ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                },
                child: const Text("Logg inn"),
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 60),
                    textStyle: const TextStyle(fontSize: 30)),
              )),
          const Spacer(flex: 10),
          const Flexible(
              flex: 4,
              child: Text(
                  "Om du ikker har en brukerkonto ennå, kan du oprette en her:")),
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

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Material(
            child: Row(children: [
      const Flexible(flex: 10, child: Center(child: WelcomeInfo())),
      Flexible(flex: 1, child: Container(color: Colors.yellow)),
      Flexible(
          flex: 10,
          child: Center(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 150),
            child: LoginForm(key),
          ))),
    ])));
  }
}

class WelcomeInfo extends StatelessWidget {
  const WelcomeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: const [
        Text("Overskrift", style: TextStyle(fontSize: 70)),
        SizedBox(
          height: 40,
        ),
        Expanded(
            child: Image(
          image: AssetImage('../assets/sheep.jpg'),
        )),
        SizedBox(
          height: 40,
        ),
        Text("Forklaring\n"),
      ],
    ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm(Key? key) : super(key: key);

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
          const Flexible(
              child: FractionallySizedBox(
            heightFactor: 0.7,
          )),
          const Icon(
            Icons.account_circle,
            size: 200,
          ),
          const Flexible(
              child: FractionallySizedBox(
            heightFactor: 0.1,
          )),
          TextFormField(
            autofocus: true,
            textAlign: TextAlign.left,
            validator: _validateUserName,
            decoration: const InputDecoration(
                hintText: "Brukernavn", border: OutlineInputBorder()),
          ),
          const Flexible(
              child: FractionallySizedBox(
            heightFactor: 0.1,
          )),
          TextFormField(
              textAlign: TextAlign.left,
              validator: _validatePassword,
              obscureText: _visiblePassword,
              decoration: InputDecoration(
                  hintText: "Passord",
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: _toggleVisiblePassword),
                  border: const OutlineInputBorder())),
          const Flexible(
              child: FractionallySizedBox(
            heightFactor: 0.1,
          )),
          ElevatedButton(
              onPressed: () {
                _formKey.currentState!.validate();
              },
              child: const Text("Logg inn"))
        ]));
  }
}

    /*return Form(
        key: _formKey,
        child: Column(
          children: [
            const Icon(Icons.account_circle, size: 180),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              autofocus: true,
              textAlign: TextAlign.left,
              validator: _validateUserName,
              decoration: const InputDecoration(
                  hintText: "Brukernavn", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30 //TODO sette til const,
                ),
            TextFormField(
                textAlign: TextAlign.left,
                validator: _validatePassword,
                obscureText: _visiblePassword,
                decoration: InputDecoration(
                    hintText: "Passord",
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: _toggleVisiblePassword),
                    border: const OutlineInputBorder())),
            const SizedBox(height: 40 //TODO sette til const,
                ),
            ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                },
                child: const Text("Logg inn"))
          ],
        ));
  }*/


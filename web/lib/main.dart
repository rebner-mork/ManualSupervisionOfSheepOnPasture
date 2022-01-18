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
            child: Row(
      children: [
        const WelcomeInfo(),
        const Padding(
            padding: EdgeInsets.symmetric(
                vertical: 100), //TODO bruke symetric constructor
            child: VerticalDivider(
              color: Colors.black,
            )),
        LoginForm(key),
      ],
    )));
  }
}

class WelcomeInfo extends StatelessWidget {
  const WelcomeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        Text("Overskrift", style: TextStyle(fontSize: 70)),
        SizedBox(
          height: 40,
        ),
        Image.network(
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        SizedBox(
          height: 40,
        ),
        Text("Forklaring\n" * 10),
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
    return Expanded(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  //TODO fjerne med å sette padding på heile widgeten
                  height: 200,
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
            )));
  }
}

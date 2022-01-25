import 'package:app/login/login_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(Key? key) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  _LoginState();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FractionallySizedBox(
      widthFactor: 0.6,
      child: Column(
        children: [
          const Spacer(flex: 3),
          Flexible(
            child: LoginWidget(widget.key),
            flex: 12,
          ),
          Flexible(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
                child: const Text('Registrer ny bruker')),
            flex: 2,
          )
        ],
      ),
    ));
  }
}

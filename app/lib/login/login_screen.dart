import 'package:app/login/login_widget.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(Key? key) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  _LoginState();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
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
                onPressed: () {}, child: const Text('Registrer ny bruker')),
            flex: 2,
          )
        ],
      ),
    );
  }
}

import 'package:app/register/register_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(Key? key) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  _RegisterState();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FractionallySizedBox(
      widthFactor: 0.6,
      child: Column(
        children: [
          const Spacer(flex: 1),
          Flexible(
            child: RegisterWidget(widget.key),
            flex: 20,
          ),
        ],
      ),
    ));
  }
}

import 'package:app/sign_up/sign_up_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();

  static const String route = 'register-user';
}

class _SignUpPageState extends State<SignUpPage> {
  _SignUpPageState();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: const [
          Spacer(),
          Flexible(
              flex: 20,
              child: SingleChildScrollView(
                  key: Key('scrollView'), child: SignUpWidget())),
        ],
      ),
    );
  }
}

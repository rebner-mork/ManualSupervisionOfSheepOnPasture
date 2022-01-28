import 'package:flutter/material.dart';
import 'package:web/register/register_user_widget.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUserPage> {
  _RegisterUserState();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FractionallySizedBox(
      widthFactor: 0.6,
      child: Column(
        children: const [
          Spacer(),
          Flexible(
            child: RegisterUserWidget(),
            flex: 20,
          ),
        ],
      ),
    ));
  }
}

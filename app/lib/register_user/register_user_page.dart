import 'package:app/register_user/register_user_widget.dart';
import 'package:flutter/material.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  _RegisterUserPageState();

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

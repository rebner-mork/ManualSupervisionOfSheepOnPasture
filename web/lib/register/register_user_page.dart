import 'package:flutter/material.dart';
import 'package:web/register/register_user_widget.dart';

class RegisterUserPage extends StatelessWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  static const String route = 'register-user-page';

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

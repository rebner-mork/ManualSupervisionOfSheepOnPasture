import 'package:app/login/login_widget.dart';
import 'package:app/register_user/register_user_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

  static const String route = 'login';
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: FractionallySizedBox(
      widthFactor: 0.6,
      child: Column(
        children: [
          const Spacer(flex: 3),
          const Flexible(
            child: LoginWidget(),
            flex: 12,
          ),
          Flexible(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterUserPage.route);
                },
                child: const Text('Registrer ny bruker')),
            flex: 2,
          )
        ],
      ),
    ));
  }
}

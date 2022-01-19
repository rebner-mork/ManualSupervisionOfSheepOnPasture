import 'package:flutter/material.dart';
import 'login_widget.dart';

class LogInView extends StatelessWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(children: [
      const Flexible(flex: 10, child: Center(child: WelcomeInfo())),
      Flexible(flex: 1, child: Container(color: Colors.yellow)),
      Flexible(
          flex: 10,
          child: Center(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 150),
            child: const LoginForm(),
          ))),
    ]));
  }
}

class WelcomeInfo extends StatelessWidget {
  const WelcomeInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        const Text("Overskrift", style: TextStyle(fontSize: 70)),
        const SizedBox(
          height: 40,
        ),
        Expanded(child: Image.asset('images/sheep.jpg')),
        const SizedBox(
          height: 40,
        ),
        const Text("Forklaring\n"),
      ],
    ));
  }
}

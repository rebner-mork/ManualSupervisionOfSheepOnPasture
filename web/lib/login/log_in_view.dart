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
            child: LoginForm(key),
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
      children: const [
        Text("Overskrift", style: TextStyle(fontSize: 70)),
        SizedBox(
          height: 40,
        ),
        Expanded(
            child: Image(
          image: AssetImage('../assets/sheep.jpg'),
        )),
        SizedBox(
          height: 40,
        ),
        Text("Forklaring\n"),
      ],
    ));
  }
}

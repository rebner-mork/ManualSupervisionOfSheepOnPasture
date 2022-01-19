import 'package:flutter/material.dart';
import 'login_widget.dart';

class LogInView extends StatelessWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(children: [
      const Flexible(flex: 80, child: Center(child: WelcomePicture())),
      Flexible(flex: 1, child: Container(color: Colors.black)),
      Flexible(
          flex: 60,
          child: Center(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 150),
            child: const LoginForm(),
          ))),
    ]));
  }
}

class WelcomePicture extends StatelessWidget {
  const WelcomePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      foregroundDecoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/sheep.jpg'), fit: BoxFit.fill)),
    ));
  }
}

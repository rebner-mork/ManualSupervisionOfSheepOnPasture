import 'package:flutter/material.dart';
import 'login_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
            child: Column(
              children: const [
                Spacer(flex: 5),
                LoginForm(),
                Spacer(flex: 10),
                Flexible(flex: 5, child: CreateUserButton()),
                Spacer()
              ],
            ),
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
        image: AssetImage('images/sheep.jpg'),
        fit: BoxFit.fill,
      )),
    ));
  }
}

class CreateUserButton extends StatelessWidget {
  const CreateUserButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: const Text("Oprett brukerkonto"),
        onPressed:
            null, // TODO Navigator.pushNamed(context, 'name to new view')
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 60),
            textStyle: const TextStyle(fontSize: 30)));
  }
}

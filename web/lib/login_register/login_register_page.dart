import 'package:flutter/material.dart';
import 'package:web/login_register/register_user_widget.dart';
import 'login_widget.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({Key? key}) : super(key: key);

  static const String route = 'login-register-page';

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(children: [
      const Flexible(flex: 80, child: Center(child: WelcomePicture())),
      Container(
        color: Colors.black,
        constraints: const BoxConstraints(minWidth: 4, maxWidth: 4),
      ),
      Flexible(
          flex: 60,
          child: Center(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Spacer(flex: _isLogin ? 5 : 1),
                _isLogin ? const LoginForm() : const RegisterUserWidget(),
                Spacer(flex: _isLogin ? 10 : 1),
                Flexible(
                    flex: 5,
                    child: ElevatedButton(
                        child: _isLogin
                            ? const Text("Opprett bruker")
                            : const Text(
                                'Har du allerede bruker?\nLogg inn',
                                textAlign: TextAlign.center,
                              ),
                        onPressed: () => {
                              setState(() {
                                _isLogin = !_isLogin;
                              })
                            },
                        style: ElevatedButton.styleFrom(
                            fixedSize: _isLogin
                                ? const Size(250, 45)
                                : const Size(250, 55),
                            textStyle:
                                TextStyle(fontSize: _isLogin ? 24 : 20)))),
                const SizedBox(height: 10)
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

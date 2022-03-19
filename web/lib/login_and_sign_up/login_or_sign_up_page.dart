import 'package:flutter/material.dart';
import 'package:web/login_and_sign_up/sign_up_widget.dart';
import 'login_widget.dart';

class LoginOrSignUpPage extends StatefulWidget {
  const LoginOrSignUpPage({Key? key}) : super(key: key);

  static const String route = 'login-register-page';

  @override
  State<LoginOrSignUpPage> createState() => _LoginOrSignUpPageState();
}

class _LoginOrSignUpPageState extends State<LoginOrSignUpPage> {
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
                _isLogin ? const LoginWidget() : const SignUpWidget(),
                Spacer(flex: _isLogin ? 10 : 1),
                if (!_isLogin)
                  const Text(
                    'Har du allerede brukerkonto?',
                    style: TextStyle(fontSize: 16),
                  ),
                Flexible(
                    flex: 5,
                    child: ElevatedButton(
                        child: _isLogin
                            ? const Text("Opprett brukerkonto")
                            : const Text(
                                'Logg inn',
                                textAlign: TextAlign.center,
                              ),
                        onPressed: () => {
                              setState(() {
                                _isLogin = !_isLogin;
                              })
                            },
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 45),
                            textStyle: const TextStyle(fontSize: 24)))),
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

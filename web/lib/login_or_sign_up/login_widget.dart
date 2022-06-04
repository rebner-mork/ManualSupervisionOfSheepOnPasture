import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web/main_tabs/main_tabs.dart';
import 'package:web/utils/authentication.dart' as authentication;
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';
import '../utils/validation.dart' as validation;

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = true;
  String _email = '';
  String _password = '';
  String _loginMessage = '';
  bool _validationActivated = false;

  final FocusNode _passwordFocusNode = FocusNode();

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  Future<void> _logIn() async {
    String tmp = '';
    setState(() {
      _validationActivated = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      tmp = await authentication.signIn(email: _email, password: _password);
      if (tmp == '') {
        Navigator.pushNamed(context, MainTabs.route);
      } else {
        setState(() {
          _loginMessage = tmp;
        });
      }
    }
  }

  void _onFieldChange(String input) {
    if (_validationActivated) {
      _formKey.currentState!.save();
      _formKey.currentState!.validate();
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          const Icon(
            Icons.account_circle,
            size: 200,
            color: Colors.black,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextFormField(
                key: const Key('inputEmail'),
                autofocus: true,
                textAlign: TextAlign.left,
                validator: (input) => validation.validateEmail(input),
                onChanged: _onFieldChange,
                onSaved: (input) => _email = input.toString(),
                onFieldSubmitted: (_) {
                  _logIn();
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    labelText: "E-post",
                    border: OutlineInputBorder()),
              )),
          const InputFieldSpacer(),
          Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: RawKeyboardListener(
                  focusNode: _passwordFocusNode,
                  onKey: (RawKeyEvent event) {
                    if (event.logicalKey == LogicalKeyboardKey.tab) {
                      _passwordFocusNode.nextFocus();
                    }
                  },
                  child: TextFormField(
                      key: const Key('inputPassword'),
                      textAlign: TextAlign.left,
                      validator: (input) => validation.validatePassword(input),
                      obscureText: _visiblePassword,
                      onChanged: _onFieldChange,
                      onSaved: (input) => _password = input.toString(),
                      onFieldSubmitted: (_) {
                        _logIn();
                      },
                      decoration: customInputDecoration(
                          labelText: 'Passord',
                          icon: Icons.lock,
                          passwordField: true,
                          isVisible: !_visiblePassword,
                          onPressed: _toggleVisiblePassword)))),
          const SizedBox(
            height: 5,
          ),
          Text(
            _loginMessage,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: _logIn,
            child: const Text("Logg inn"),
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(250, 60),
              textStyle: const TextStyle(fontSize: 28),
            ),
          ),
        ]));
  }
}

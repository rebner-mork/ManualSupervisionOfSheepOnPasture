import 'package:web/utils/authentication.dart';
import 'package:web/utils/validation.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class RegisterUserWidget extends StatefulWidget {
  const RegisterUserWidget({Key? key}) : super(key: key);

  @override
  State<RegisterUserWidget> createState() => _RegisterUserWidgetState();
}

class _RegisterUserWidgetState extends State<RegisterUserWidget> {
  _RegisterUserWidgetState();

  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = false;
  bool _registerFailed = false;
  String _feedback = '';
  bool _validationActivated = false;
  late String _email, _password, _phone;
  final passwordOneController = TextEditingController();

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  void _onFieldChanged() {
    if (_registerFailed) {
      setState(() {
        _registerFailed = false;
      });
    }

    if (_validationActivated) {
      _formKey.currentState!.save();
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.account_circle,
                    size: 90, color: Colors.black54),
                inputFieldSpacer(),
                TextFormField(
                    key: const Key('inputEmail'),
                    validator: (input) => validateEmail(input),
                    onSaved: (input) => _email = input.toString(),
                    onChanged: (_) {
                      _onFieldChanged();
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => _createUser(),
                    decoration: customInputDecoration('E-post', Icons.mail)),
                inputFieldSpacer(),
                TextFormField(
                    controller: passwordOneController,
                    key: const Key('inputPasswordOne'),
                    validator: (input) => validatePassword(input),
                    onSaved: (input) => _password = input.toString(),
                    onChanged: (_) {
                      _onFieldChanged();
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => _createUser(),
                    obscureText: !_visiblePassword,
                    decoration: customInputDecoration('Passord', Icons.lock,
                        passwordField: true,
                        isVisible: _visiblePassword,
                        onPressed: _toggleVisiblePassword)),
                inputFieldSpacer(),
                TextFormField(
                    key: const Key('inputPasswordTwo'),
                    validator: (input) =>
                        validatePasswords(passwordOneController.text, input),
                    onChanged: (_) {
                      _onFieldChanged();
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => _createUser(),
                    obscureText: !_visiblePassword,
                    decoration: customInputDecoration(
                        'Gjenta passord', Icons.lock,
                        passwordField: true,
                        isVisible: _visiblePassword,
                        onPressed: _toggleVisiblePassword)),
                inputFieldSpacer(),
                TextFormField(
                    key: const Key('inputPhone'),
                    validator: (input) => validatePhone(input),
                    onSaved: (input) => _phone = input.toString(),
                    onChanged: (_) {
                      _onFieldChanged();
                    },
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) => _createUser(),
                    decoration: customInputDecoration('Telefon', Icons.phone)),
                inputFieldSpacer(),
                AnimatedOpacity(
                  opacity: _registerFailed ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    _feedback,
                    key: const Key('feedback'),
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: _createUser,
                    child: const Text('Opprett bruker',
                        style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 60)))
              ],
            )));
  }

  void _createUser() async {
    final formState = _formKey.currentState;

    setState(() {
      _validationActivated = true;
    });

    if (formState!.validate()) {
      formState.save();
      try {
        String? response = await createUser(_email, _password, _phone);

        setState(() {
          _registerFailed = response == null ? false : true;
          _feedback = response ?? '';
        });
      } catch (e) {
        _feedback = 'Kunne ikke opprette bruker';
        debugPrint(e.toString());
        setState(() {
          _validationActivated = true;
          _registerFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordOneController.dispose();
    super.dispose();
  }
}
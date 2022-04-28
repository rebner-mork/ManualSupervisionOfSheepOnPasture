import 'package:app/trip/start_trip_page.dart';
import 'package:app/utils/authentication.dart';
import 'package:app/utils/field_validation.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  _SignUpWidgetState();

  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = false;
  bool _registerFailed = false;
  bool _validationActivated = false;
  late String _name, _email, _password, _phone, _feedback;
  final passwordOneController = TextEditingController();

  void _toggleVisiblePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  void _onFieldChange(String input) {
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
            child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewPadding.top -
                    MediaQuery.of(context).viewInsets.bottom,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                      horizontal: 0.175 * MediaQuery.of(context).size.width),
                  children: [
                    const Icon(Icons.account_circle,
                        size: 90, color: Colors.black54),
                    const InputFieldSpacer(),
                    TextFormField(
                        key: const Key('inputName'),
                        textCapitalization: TextCapitalization.words,
                        validator: (input) => validateName(input!.trim()),
                        onSaved: (input) => _name = input!.trim(),
                        onChanged: _onFieldChange,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => _createUser(),
                        decoration:
                            customInputDecoration('Fullt navn', Icons.badge)),
                    const InputFieldSpacer(),
                    TextFormField(
                        key: const Key('inputEmail'),
                        validator: (input) => validateEmail(input),
                        onSaved: (input) => _email = input.toString(),
                        onChanged: _onFieldChange,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => _createUser(),
                        decoration:
                            customInputDecoration('E-post', Icons.mail)),
                    const InputFieldSpacer(),
                    TextFormField(
                        controller: passwordOneController,
                        key: const Key('inputPasswordOne'),
                        validator: (input) => validatePassword(input),
                        onSaved: (input) => _password = input.toString(),
                        onChanged: _onFieldChange,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => _createUser(),
                        obscureText: !_visiblePassword,
                        decoration: customInputDecoration('Passord', Icons.lock,
                            passwordField: true,
                            isVisible: _visiblePassword,
                            onPressed: _toggleVisiblePassword)),
                    const InputFieldSpacer(),
                    TextFormField(
                        key: const Key('inputPasswordTwo'),
                        validator: (input) => validatePasswords(
                            passwordOneController.text, input),
                        onChanged: _onFieldChange,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => _createUser(),
                        obscureText: !_visiblePassword,
                        decoration: customInputDecoration(
                            'Gjenta passord', Icons.lock,
                            passwordField: true,
                            isVisible: _visiblePassword,
                            onPressed: _toggleVisiblePassword)),
                    const InputFieldSpacer(),
                    TextFormField(
                        key: const Key('inputPhone'),
                        validator: (input) => validatePhone(input),
                        onSaved: (input) => _phone = input.toString(),
                        onChanged: _onFieldChange,
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: (value) => _createUser(),
                        decoration:
                            customInputDecoration('Telefon', Icons.phone)),
                    const InputFieldSpacer(),
                    AnimatedOpacity(
                      opacity: _registerFailed ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _registerFailed ? _feedback : '',
                        key: const Key('feedback'),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        key: const Key('registerUserButton'),
                        onPressed: _createUser,
                        child: const Text('Opprett bruker',
                            style: TextStyle(fontSize: 20)),
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(180, 60)))
                  ],
                ))));
  }

  void _createUser() async {
    final formState = _formKey.currentState;

    setState(() {
      _validationActivated = true;
    });

    if (formState!.validate()) {
      formState.save();
      try {
        String? response = await createUser(_name, _email, _password, _phone);

        setState(() {
          _registerFailed = response == null ? false : true;
          _feedback = response ?? '';
        });
        if (response == null) {
          Navigator.popAndPushNamed(context, StartTripPage.route);
        }
      } catch (e) {
        _feedback = 'Kunne ikke opprette bruker';
        if (mounted) {
          setState(() {
            _validationActivated = true;
            _registerFailed = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    passwordOneController.dispose();
    super.dispose();
  }
}

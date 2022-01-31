import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

class RegisterSheep extends StatefulWidget {
  const RegisterSheep({Key? key}) : super(key: key);

  @override
  State<RegisterSheep> createState() => _RegisterSheepState();

  static const String route = 'register-sheep';
}

class _RegisterSheepState extends State<RegisterSheep> {
  _RegisterSheepState();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Registrer sau'),
                leading:
                    BackButton(onPressed: () => Navigator.of(context).pop()),
              ),
              body: Center(
                  child: Column(children: [
                const SizedBox(height: 10),
                const Text(
                  'Antall',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                customInputRow('Sauer'),
                inputFieldSpacer(),
                customInputRow('Lam'),
                inputFieldSpacer(),
                customInputRow('Hvite'),
                inputFieldSpacer(),
                customInputRow('Svarte'),
                inputFieldSpacer(),
                customInputRow('Svart hode'),
                const SizedBox(height: 5),
                const FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Divider(
                      thickness: 5,
                      color: Colors.amber,
                    )),
                const SizedBox(height: 5),
                const Text(
                  'Slips',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                // TODO: Conditional basert på mulige farger
                customInputRow('Røde'),
                inputFieldSpacer(),
                customInputRow('Blå'),
                inputFieldSpacer(),
                customInputRow('Gule'),
                // TODO: Conditional basert på mulige farger
              ])),
            )));
  }
}

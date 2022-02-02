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
                leading: BackButton(
                    onPressed: () => Navigator.of(context)
                        .pop()), // TODO: Popup sikker? Bare hvis noe er fylt ut
              ),
              body: SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                const SizedBox(height: 10),
                inputDividerWithHeadline('Antall'),

                customInputRow('Sauer'),
                inputFieldSpacer(),
                customInputRow('Lam'),
                inputFieldSpacer(),
                customInputRow('Hvite', color: Colors.white),
                inputFieldSpacer(),
                customInputRow('Svarte', color: Colors.black),
                inputFieldSpacer(),
                customInputRow('Svart hode', color: Colors.black),
                const SizedBox(height: 5),

                inputDividerWithHeadline('Slips'),

                // TODO: Conditional basert på mulige farger
                customInputRow('Røde', color: Colors.red),
                inputFieldSpacer(),
                customInputRow('Blå', color: Colors.blue),
                inputFieldSpacer(),
                customInputRow('Gule', color: Colors.yellow),
                // TODO: Conditional basert på mulige farger

                inputDividerWithHeadline('Øremerker'),

                customInputRow('Røde', color: Colors.red),
                inputFieldSpacer(),
                customInputRow('Blå', color: Colors.blue),
                const SizedBox(height: 10),
              ]))),
            )));
  }
}

FractionallySizedBox customDivider() {
  return const FractionallySizedBox(
      widthFactor: 0.4,
      child: Divider(
        thickness: 5,
        color: Colors.amber,
      ));
}

Column inputDividerWithHeadline(String headline) {
  return Column(children: [
    const SizedBox(height: 5),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Flexible(
          child: Divider(
        thickness: 5,
        color: Colors.grey, //Colors.amber,
        endIndent: 5,
      )),
      Flexible(
          flex: 5,
          child: Text(
            headline,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          )),
      const Flexible(
          child: Divider(
        thickness: 5,
        color: Colors.grey, //Colors.amber,
        indent: 5,
      ))
    ]),
    const SizedBox(height: 5),
  ]);
}

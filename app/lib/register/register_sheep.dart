import 'dart:ui';

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

  final TextEditingController _sheepController = TextEditingController(),
      _lambsController = TextEditingController(),
      _blackController = TextEditingController(),
      _whiteController = TextEditingController(),
      _blackHeadController = TextEditingController(),
      _redTieController = TextEditingController(),
      _blueTieController = TextEditingController(),
      _yellowTieController = TextEditingController(),
      _redEarController = TextEditingController(),
      _blueEarController = TextEditingController();

  /*AlertDialog alert = AlertDialog(
    title: const Text("Avbryte registrering?"),
    content: const Text('Data i denne registreringen vil gå tapt.'),
    actions: [
      TextButton(onPressed: () {}, child: Text('Ja, avbryt')),
      TextButton(onPressed: () {}, child: Text('Nei, fortsett'))
    ],
  );*/

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
            key: _formKey,
            child: Scaffold(
                appBar: AppBar(
                  title: const Text('Registrer sau'),
                  leading: BackButton(
                      onPressed: () => {
                            //Navigator.of(context).pop()
                            showDialog(
                                context: context,
                                builder: (_) => BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                    child: AlertDialog(
                                      title:
                                          const Text("Avbryte registrering?"),
                                      content: const Text(
                                          'Data i registreringen vil gå tapt.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop('dialog');
                                              if (Navigator.canPop(context))
                                                Navigator.of(context).pop();
                                            },
                                            child: Text('Ja, avbryt')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop('dialog');
                                            },
                                            child: Text('Nei, fortsett'))
                                      ],
                                    )))
                          }), // TODO: Popup sikker? Bare hvis noe er fylt ut
                ),
                body: SingleChildScrollView(
                    child: Center(
                        child: Column(children: [
                  const SizedBox(height: 10),
                  inputDividerWithHeadline('Antall'),
                  customInputRow('Sauer', _sheepController), // Større tekst
                  inputFieldSpacer(),
                  customInputRow('Lam', _lambsController),
                  inputFieldSpacer(),
                  customInputRow('Hvite', _whiteController,
                      color: Colors.white),
                  inputFieldSpacer(),
                  customInputRow('Svarte', _blackController,
                      color: Colors.black),
                  inputFieldSpacer(),
                  customInputRow('Svart hode', _blackHeadController,
                      color: Colors.black),
                  const SizedBox(height: 5),

                  inputDividerWithHeadline('Slips'),

                  // TODO: Conditional basert på mulige farger
                  customInputRow('Røde', _redTieController,
                      color: Colors.red), // TODO: fargede slips
                  inputFieldSpacer(),
                  customInputRow('Blå', _blueTieController, color: Colors.blue),
                  inputFieldSpacer(),
                  customInputRow('Gule', _yellowTieController,
                      color: Colors.yellow),
                  // TODO: Conditional basert på mulige farger

                  inputDividerWithHeadline('Øremerker'),

                  customInputRow('Røde', _redEarController, color: Colors.red),
                  inputFieldSpacer(),
                  customInputRow('Blå', _blueEarController, color: Colors.blue),
                  const SizedBox(height: 80),
                ]))),
                floatingActionButton: // Større kart
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButton.extended(
                            onPressed: () {},
                            label: const Text('Fullfør registrering'))
                        : FloatingActionButton(
                            onPressed: () {}, child: const Icon(Icons.add)),
                floatingActionButtonLocation:
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButtonLocation.centerFloat
                        : FloatingActionButtonLocation.endFloat)));
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
        thickness: 3,
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
        thickness: 3,
        color: Colors.grey, //Colors.amber,
        indent: 5,
      ))
    ]),
    const SizedBox(height: 5),
  ]);
}

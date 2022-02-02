import 'dart:ui';

import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

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
                                              if (Navigator.canPop(context)) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: const Text('Ja, avbryt')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop('dialog');
                                            },
                                            child: const Text('Nei, fortsett'))
                                      ],
                                    )))
                          }),
                ),
                body: SingleChildScrollView(
                    child: Center(
                        child: Column(children: [
                  const SizedBox(height: 10),
                  inputDividerWithHeadline('Antall'),
                  customInputRow('Sauer', _sheepController, RpgAwesome.sheep,
                      Colors.grey), // Større tekst
                  inputFieldSpacer(),
                  customInputRow(
                      'Lam', _lambsController, RpgAwesome.sheep, Colors.grey),
                  inputFieldSpacer(),
                  customInputRow('Hvite', _whiteController, RpgAwesome.sheep,
                      Colors.white),
                  inputFieldSpacer(),
                  customInputRow('Svarte', _blackController, RpgAwesome.sheep,
                      Colors.black),
                  inputFieldSpacer(),
                  customInputRow('Svart hode', _blackHeadController,
                      RpgAwesome.sheep, Colors.black),

                  inputDividerWithHeadline('Slips'),

                  // TODO: Conditional basert på mulige farger
                  customInputRow(
                      'Røde',
                      _redTieController,
                      FontAwesome5.black_tie,
                      Colors.red), // TODO: fargede slips
                  inputFieldSpacer(),
                  customInputRow('Blå', _blueTieController,
                      FontAwesome5.black_tie, Colors.blue),
                  inputFieldSpacer(),
                  customInputRow('Gule', _yellowTieController,
                      FontAwesome5.black_tie, Colors.yellow),
                  // TODO: Conditional basert på mulige farger

                  inputDividerWithHeadline('Øremerker'),

                  customInputRow(
                      'Røde', _redEarController, Icons.local_offer, Colors.red),
                  inputFieldSpacer(),
                  customInputRow('Blå', _blueEarController, Icons.local_offer,
                      Colors.blue),
                  const SizedBox(height: 80),
                ]))),
                floatingActionButton: // Større kart
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButton.extended(
                            onPressed: () {},
                            label: const Text('Fullfør registrering'))
                        : FloatingActionButton(
                            onPressed: () {}, child: const Icon(Icons.check)),
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
    const SizedBox(height: 10),
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
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          )),
      const Flexible(
          child: Divider(
        thickness: 3,
        color: Colors.grey, //Colors.amber,
        indent: 5,
      ))
    ]),
    const SizedBox(height: 10),
  ]);
}

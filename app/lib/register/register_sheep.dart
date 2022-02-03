import 'dart:convert';
import 'dart:io';

import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:path_provider/path_provider.dart';

class RegisterSheep extends StatefulWidget {
  const RegisterSheep(this.fileName, {Key? key}) : super(key: key);

  final String fileName;
  static const String route = 'register-sheep';

  @override
  State<RegisterSheep> createState() => _RegisterSheepState();
}

class _RegisterSheepState extends State<RegisterSheep> {
  _RegisterSheepState();

  final scrollController = ScrollController();

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

  Widget rad = customInputDividerWithHeadline('HEI');

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
                                builder: (_) =>
                                    customCancelRegistrationDialog(context))
                          }),
                ),
                body: SingleChildScrollView(
                    controller: scrollController,
                    child: Center(
                        child: Column(children: [
                      const SizedBox(height: 10),
                      customInputDividerWithHeadline('Antall'),
                      customInputRow('Sauer', _sheepController,
                          RpgAwesome.sheep, Colors.grey),
                      inputFieldSpacer(),
                      customInputRow('Lam', _lambsController, RpgAwesome.sheep,
                          Colors.grey,
                          iconSize: 24),
                      inputFieldSpacer(),

                      customInputRow(
                        'Hvite',
                        _whiteController,
                        RpgAwesome.sheep,
                        Colors.white,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Svarte',
                        _blackController,
                        RpgAwesome.sheep,
                        Colors.black,
                      ),
                      inputFieldSpacer(),
                      customInputRow('Svart hode', _blackHeadController,
                          RpgAwesome.sheep, Colors.black,
                          scrollController: scrollController, fieldAmount: 5),

                      customInputDividerWithHeadline('Slips'),

                      // TODO: Conditional basert på mulige farger
                      customInputRow(
                        'Røde',
                        _redTieController,
                        FontAwesome5.black_tie,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Blå',
                        _blueTieController,
                        FontAwesome5.black_tie,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      customInputRow('Gule', _yellowTieController,
                          FontAwesome5.black_tie, Colors.yellow,
                          scrollController: scrollController, fieldAmount: 3),
                      // TODO: Conditional basert på mulige farger

                      customInputDividerWithHeadline('Øremerker'),

                      customInputRow(
                        'Røde',
                        _redEarController,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Blå',
                        _blueEarController,
                        Icons.local_offer,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Røde',
                        _redEarController,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Røde',
                        _redEarController,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Røde',
                        _redEarController,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Røde',
                        _redEarController,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Røde',
                        _redEarController,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      const SizedBox(height: 80),
                    ]))),
                floatingActionButton: // Større kart
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButton.extended(
                            onPressed: _registerSheep,
                            label: const Text('Fullfør registrering',
                                style: TextStyle(fontSize: 19)))
                        : FloatingActionButton(
                            onPressed: _registerSheep,
                            child: const Icon(
                              Icons.check,
                              size: 35,
                            )),
                floatingActionButtonLocation:
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButtonLocation.centerFloat
                        : FloatingActionButtonLocation.endFloat)));
  }

  _registerSheep() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    final File file = File('$path/${widget.fileName}.json');
    final Map data = gatherData();

    file.writeAsString(json.encode(data));
  }

  Map gatherData() {
    return <String, int>{
      'sheep':
          _sheepController.text.isEmpty ? 0 : int.parse(_sheepController.text),
      'lambs':
          _lambsController.text.isEmpty ? 0 : int.parse(_lambsController.text),
      'white':
          _whiteController.text.isEmpty ? 0 : int.parse(_whiteController.text),
      'black':
          _blackController.text.isEmpty ? 0 : int.parse(_blackController.text),
      'blackHead': _blackHeadController.text.isEmpty
          ? 0
          : int.parse(_blackHeadController.text),
      'redTie': _redTieController.text.isEmpty
          ? 0
          : int.parse(_redTieController.text),
      'blueTie': _blueTieController.text.isEmpty
          ? 0
          : int.parse(_blueTieController.text),
      'yellowTie': _yellowTieController.text.isEmpty
          ? 0
          : int.parse(_yellowTieController.text),
      'redEar': _redEarController.text.isEmpty
          ? 0
          : int.parse(_redEarController.text),
      'blueEar': _blueEarController.text.isEmpty
          ? 0
          : int.parse(_blueEarController.text),
    };
  }
}

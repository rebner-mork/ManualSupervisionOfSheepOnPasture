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
  void initState() {
    super.initState();
    _readSheep();
  }

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
                    child: Center(
                        child: Column(children: [
                  const SizedBox(height: 10),
                  customInputDividerWithHeadline('Antall'),
                  customInputRow(
                      'Sauer', _sheepController, RpgAwesome.sheep, Colors.grey),
                  inputFieldSpacer(),
                  customInputRow(
                      'Lam', _lambsController, RpgAwesome.sheep, Colors.grey,
                      iconSize: 24),
                  inputFieldSpacer(),
                  customInputRow('Hvite', _whiteController, RpgAwesome.sheep,
                      Colors.white),
                  inputFieldSpacer(),
                  customInputRow('Svarte', _blackController, RpgAwesome.sheep,
                      Colors.black),
                  inputFieldSpacer(),
                  customInputRow('Svart hode', _blackHeadController,
                      RpgAwesome.sheep, Colors.black),

                  customInputDividerWithHeadline('Slips'),

                  // TODO: Conditional basert på mulige farger
                  customInputRow('Røde', _redTieController,
                      FontAwesome5.black_tie, Colors.red),
                  inputFieldSpacer(),
                  customInputRow('Blå', _blueTieController,
                      FontAwesome5.black_tie, Colors.blue),
                  inputFieldSpacer(),
                  customInputRow('Gule', _yellowTieController,
                      FontAwesome5.black_tie, Colors.yellow),
                  // TODO: Conditional basert på mulige farger

                  customInputDividerWithHeadline('Øremerker'),

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

  // TODO:keyboadrd next + focus
  _registerSheep() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    File file = File('$path/${widget.fileName}.json');

    // TODO: dynamic --> int?
    Map data = <String, int>{
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

    file.writeAsString(json.encode(data));
    debugPrint("Skrev til fil");
  }

  _readSheep() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;

    File file = File('$path/${widget.fileName}.json');

    final contents = await file.readAsString();

    debugPrint("string: " + contents);

    final decoded = json.decode(contents);

    file.delete();
    debugPrint("slettet fil");
  }
}

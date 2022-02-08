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
  final headlineTwoKey = GlobalKey();
  final headlineThreeKey = GlobalKey();

  final _formKey = GlobalKey<FormState>();

  final _textControllers = <String, TextEditingController>{
    'sheep': TextEditingController(),
    'lambs': TextEditingController(),
    'black': TextEditingController(),
    'white': TextEditingController(),
    'blackHead': TextEditingController(),
    'redTie': TextEditingController(),
    'blueTie': TextEditingController(),
    'yellowTie': TextEditingController(),
    'redEar': TextEditingController(),
    'blueEar': TextEditingController(),
  };

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
                      customInputRow('Sauer', _textControllers['sheep']!,
                          RpgAwesome.sheep, Colors.grey),
                      inputFieldSpacer(),
                      customInputRow('Lam', _textControllers['lambs']!,
                          RpgAwesome.sheep, Colors.grey,
                          iconSize: 24),
                      inputFieldSpacer(),

                      customInputRow(
                        'Hvite',
                        _textControllers['white']!,
                        RpgAwesome.sheep,
                        Colors.white,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Svarte',
                        _textControllers['black']!,
                        RpgAwesome.sheep,
                        Colors.black,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                          'Svart hode',
                          _textControllers['blackHead']!,
                          RpgAwesome.sheep,
                          Colors.black,
                          scrollController: scrollController,
                          fieldAmount: 5,
                          key: headlineTwoKey),

                      customInputDividerWithHeadline('Slips', headlineTwoKey),

                      // TODO: Conditional basert på mulige farger
                      customInputRow(
                        'Røde',
                        _textControllers['redTie']!,
                        FontAwesome5.black_tie,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Blå',
                        _textControllers['blueTie']!,
                        FontAwesome5.black_tie,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      customInputRow('Gule', _textControllers['yellowTie']!,
                          FontAwesome5.black_tie, Colors.yellow,
                          scrollController: scrollController,
                          fieldAmount: 3,
                          key: headlineThreeKey),
                      // TODO: Conditional basert på mulige farger

                      customInputDividerWithHeadline(
                          'Øremerker', headlineThreeKey),

                      customInputRow(
                        'Røde',
                        _textControllers['redEar']!,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      customInputRow(
                        'Blå',
                        _textControllers['blueEar']!,
                        Icons.local_offer,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      const SizedBox(height: 80),
                    ]))),
                floatingActionButton:
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
    final Map data = _gatherData();

    file.writeAsString(json.encode(data));
  }

  Map _gatherData() {
    return <String, int>{
      'sheep': _textControllers['sheep']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['sheep']!.text),
      'lambs': _textControllers['lambs']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['lambs']!.text),
      'white': _textControllers['white']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['white']!.text),
      'black': _textControllers['black']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['black']!.text),
      'blackHead': _textControllers['blackHead']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['blackHead']!.text),
      'redTie': _textControllers['redTie']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['redTie']!.text),
      'blueTie': _textControllers['blueTie']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['blueTie']!.text),
      'yellowTie': _textControllers['yellowTie']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['yellowTie']!.text),
      'redEar': _textControllers['redEar']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['redEar']!.text),
      'blueEar': _textControllers['blueEar']!.text.isEmpty
          ? 0
          : int.parse(_textControllers['blueEar']!.text),
    };
  }
}

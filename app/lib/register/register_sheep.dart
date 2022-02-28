import 'dart:convert';
import 'dart:io';

import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:path_provider/path_provider.dart';

class RegisterSheep extends StatefulWidget {
  const RegisterSheep(this.fileName, {this.onCompletedSuccessfully, Key? key})
      : super(key: key);

  final String fileName;
  final VoidCallback? onCompletedSuccessfully;

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
                                    cancelRegistrationDialog(context))
                          }),
                ),
                body: SingleChildScrollView(
                    controller: scrollController,
                    child: Center(
                        child: Column(children: [
                      const SizedBox(height: 10),
                      inputDividerWithHeadline('Antall'),
                      inputRow('Sauer', _textControllers['sheep']!,
                          RpgAwesome.sheep, Colors.grey),
                      inputFieldSpacer(),
                      inputRow('Lam', _textControllers['lambs']!,
                          RpgAwesome.sheep, Colors.grey,
                          iconSize: 24),
                      inputFieldSpacer(),

                      inputRow(
                        'Hvite',
                        _textControllers['white']!,
                        RpgAwesome.sheep,
                        Colors.white,
                      ),
                      inputFieldSpacer(),
                      inputRow(
                        'Svarte',
                        _textControllers['black']!,
                        RpgAwesome.sheep,
                        Colors.black,
                      ),
                      inputFieldSpacer(),
                      inputRow('Svart hode', _textControllers['blackHead']!,
                          RpgAwesome.sheep, Colors.black,
                          scrollController: scrollController,
                          fieldAmount: 5,
                          key: headlineTwoKey),

                      inputDividerWithHeadline('Slips', headlineTwoKey),

                      // TODO: Conditional basert på mulige farger
                      inputRow(
                        'Røde',
                        _textControllers['redTie']!,
                        FontAwesome5.black_tie,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      inputRow(
                        'Blå',
                        _textControllers['blueTie']!,
                        FontAwesome5.black_tie,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      inputRow('Gule', _textControllers['yellowTie']!,
                          FontAwesome5.black_tie, Colors.yellow,
                          scrollController: scrollController,
                          fieldAmount: 3,
                          key: headlineThreeKey),
                      // TODO: Conditional basert på mulige farger

                      inputDividerWithHeadline('Øremerker', headlineThreeKey),

                      inputRow(
                        'Røde',
                        _textControllers['redEar']!,
                        Icons.local_offer,
                        Colors.red,
                      ),
                      inputFieldSpacer(),
                      inputRow(
                        'Blå',
                        _textControllers['blueEar']!,
                        Icons.local_offer,
                        Colors.blue,
                      ),
                      inputFieldSpacer(),
                      const SizedBox(height: 80),
                    ]))),
                floatingActionButton:
                    completeRegistrationButton(context, _registerSheep),
                floatingActionButtonLocation:
                    MediaQuery.of(context).viewInsets.bottom == 0
                        ? FloatingActionButtonLocation.centerFloat
                        : FloatingActionButtonLocation.endFloat)));
  }

  _registerSheep() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    final File file = File('$path/${widget.fileName}.json');
    final Map data = gatherRegisteredData(_textControllers);

    file.writeAsString(json.encode(data));

    if (widget.onCompletedSuccessfully != null) {
      widget.onCompletedSuccessfully!();
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    scrollController.dispose();
    _textControllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }
}

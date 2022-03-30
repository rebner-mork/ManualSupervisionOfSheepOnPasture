import 'package:app/trip/trip_data_manager.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class RegisterCadaver extends StatefulWidget {
  const RegisterCadaver({required this.ties, Key? key}) : super(key: key);

  static const String route = 'register-cadaver';

  final Map<String, int?> ties;

  @override
  State<RegisterCadaver> createState() => _RegisterCadaverState();
}

class _RegisterCadaverState extends State<RegisterCadaver> {
  late String dropdownValue = widget.ties.keys.first;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('Registrer kadaver')),
            ),
            body: Form(
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(children: [
                      inputFieldSpacer(),
                      const Text("Øremerke", style: TextStyle(fontSize: 25)),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Øremerke-nummer',
                              border: OutlineInputBorder())),
                      inputFieldSpacer(),
                      Row(
                        children: [
                          const Text("Slips", style: TextStyle(fontSize: 25)),
                          const SizedBox(width: 50),
                          DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: widget.ties.keys
                                .map<DropdownMenuItem<String>>(
                                    (String colorHex) {
                              return DropdownMenuItem(
                                value: colorHex,
                                child: TieDropDownItem(colorHex: colorHex),
                              );
                            }).toList(),
                          )
                        ],
                      )
                    ])))));
  }
}

class TieDropDownItem extends StatelessWidget {
  TieDropDownItem({Key? key, required String colorHex}) : super(key: key) {
    icon = Icon(FontAwesome5.black_tie,
        color: colorStringToColor[colorHex], size: 30);
    //TODO oransje
    label = colorValueStringToColorStringGui[colorHex]!;
    debugPrint(label);
  }

  late Icon icon;
  late String label;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: [
        icon,
        SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 25),
        )
      ],
    ));
  }
}

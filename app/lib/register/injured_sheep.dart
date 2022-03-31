import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../utils/map_utils.dart' as map_utils;

class RegisterInjuredSheep extends StatefulWidget {
  const RegisterInjuredSheep({required this.ties, Key? key}) : super(key: key);

  final Map<String, int?> ties;

  @override
  State<RegisterInjuredSheep> createState() => _RegisterInjuredSheepState();
}

class _RegisterInjuredSheepState extends State<RegisterInjuredSheep> {
  bool _isLoading = true;
  late LatLng _devicePosition;
  late String _tieColor;
  late final TextEditingController _eartagController;
  late Map<String, int?> _ties;

  @override
  void initState() {
    super.initState();

    _eartagController = TextEditingController(text: 'MT-NO');
    _tieColor = Colors.transparent.value.toRadixString(16);

    _ties = {...widget.ties};

    if (!_ties.keys.contains(Colors.transparent.value.toRadixString(16))) {
      _ties[Colors.transparent.value.toRadixString(16)] = null;
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getDevicePosition();
      debugPrint(_ties.toString());
    });
  }

  Future<void> _getDevicePosition() async {
    _devicePosition = await map_utils.getDevicePosition();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _backButtonPressed() async {
    await cancelRegistrationDialog(context).then((value) => {
          if (value)
            {
              //if (widget.onWillPop != null) {widget.onWillPop!()},
              Navigator.pop(context)
            }
        });
  }

  Future<bool> _onWillPop() async {
    bool returnValue = false;
    await cancelRegistrationDialog(context)
        .then((value) => {returnValue = value});
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Registrer skadd sau'),
        leading: BackButton(onPressed: _backButtonPressed),
      ),
      body: Form(
        onWillPop: _onWillPop,
        child: _isLoading
            ? const LoadingData()
            : Center(
                child: Container(
                    margin: const EdgeInsets.only(left: 40),
                    child: Column(
                      children: [
                        appbarBodySpacer(),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Øremerke",
                                style: TextStyle(fontSize: 25))),
                        inputFieldSpacer(),
                        Flexible(
                            child: Row(children: [
                          SizedBox(
                              width: 90,
                              child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _eartagController,
                                  decoration: const InputDecoration(
                                      //labelText: 'MT-NO',
                                      border: OutlineInputBorder()))),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: 120,
                              child: TextFormField(
                                  // TODO: validering
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(
                                      labelText: 'Gårds-nr',
                                      border: OutlineInputBorder()))),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: 90,
                              child: TextFormField(
                                  // TODO: validering
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(
                                      labelText: 'ID-nr',
                                      border: OutlineInputBorder())))
                          /*SizedBox(
                            width: 135,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              controller: _eartagController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(2, 0, 2, 0)),
                            ))*/
                        ])),
                        inputFieldSpacer(),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text("Slips", style: TextStyle(fontSize: 25))),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton<String>(
                              alignment: Alignment.center,
                              value: _tieColor,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _tieColor = newValue!;
                                });
                              },
                              items: _ties.keys.map<DropdownMenuItem<String>>(
                                  (String colorHex) {
                                return DropdownMenuItem(
                                  value: colorHex,
                                  child: TieDropDownItem(colorHex: colorHex),
                                );
                              }).toList(),
                            )
                          ],
                        )
                      ],
                    ))),
      ),
    ));
  }
}

class TieDropDownItem extends StatelessWidget {
  TieDropDownItem({Key? key, required String colorHex}) : super(key: key) {
    icon = Icon(FontAwesome5.black_tie,
        color: colorStringToColor[colorHex], size: 30);

    label = colorValueToStringGui[colorHex]!;
  }

  late final Icon icon; // Større
  late final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      children: [
        icon,
        const SizedBox(
          width: 10,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 25),
        )
      ],
    ));
  }
}

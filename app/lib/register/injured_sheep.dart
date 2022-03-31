import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import '../utils/map_utils.dart' as map_utils;

const TextStyle dropdownTextStyle = TextStyle(fontSize: 24);
const double dropdownArrowSize = 40;

class RegisterInjuredSheep extends StatefulWidget {
  const RegisterInjuredSheep({required this.ties, Key? key}) : super(key: key);

  final Map<String, int?> ties;

  @override
  State<RegisterInjuredSheep> createState() => _RegisterInjuredSheepState();
}

class _RegisterInjuredSheepState extends State<RegisterInjuredSheep> {
  bool _isLoading = true;
  late LatLng _devicePosition;
  late String _selectedTieColor;
  late final TextEditingController _eartagController;
  late Map<String, int?> _ties;
  static const List<String> injuryTypes = [
    'Annen',
    'Beinskade',
    'Hodeskade',
    'Blodutredning'
  ];
  late String _selectedInjuryType;

  @override
  void initState() {
    super.initState();

    _eartagController = TextEditingController(text: 'MT-NO');
    _selectedTieColor = Colors.transparent.value.toRadixString(16);

    _selectedInjuryType = injuryTypes.first;

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
                            child: Text('Øremerke',
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
                        ])),
                        inputFieldSpacer(),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text('Slips', style: TextStyle(fontSize: 25))),
                        //const SizedBox(height: 5),
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            DropdownButton<String>(
                              itemHeight: 60,
                              iconSize: dropdownArrowSize,
                              alignment: Alignment.center,
                              value: _selectedTieColor,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTieColor = newValue!;
                                });
                              },
                              items: _ties.keys
                                  .map<DropdownMenuItem<String>>(
                                      (String colorHex) => DropdownMenuItem(
                                            value: colorHex,
                                            child: TieDropDownItem(
                                                colorHex: colorHex),
                                          ))
                                  .toList(),
                            )
                          ],
                        ),
                        inputFieldSpacer(),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text('Skade', style: TextStyle(fontSize: 25))),
                        //inputFieldSpacer(),
                        const SizedBox(height: 4),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              const SizedBox(width: 15),
                              DropdownButton(
                                  iconSize: dropdownArrowSize,
                                  value: _selectedInjuryType,
                                  items: injuryTypes
                                      .map<DropdownMenuItem<String>>(
                                          (String type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(
                                                type,
                                                style: dropdownTextStyle,
                                              )))
                                      .toList(),
                                  onChanged: (String? newType) {
                                    if (_selectedInjuryType != newType!) {
                                      setState(() {
                                        _selectedInjuryType = newType;
                                      });
                                    }
                                  })
                            ])),
                        const SizedBox(height: 8),
                      ],
                    ))),
      ),
    ));
  }
}

class TieDropDownItem extends StatelessWidget {
  TieDropDownItem({Key? key, required String colorHex}) : super(key: key) {
    bool isTransparent = colorHex == '0';
    icon = Icon(
        isTransparent ? Icons.disabled_by_default : FontAwesome5.black_tie,
        color: isTransparent ? Colors.grey : colorStringToColor[colorHex],
        size: 38);

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
          style: dropdownTextStyle,
        )
      ],
    ));
  }
}

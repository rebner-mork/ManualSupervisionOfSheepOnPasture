import 'package:app/register/tie_dropdown_item.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
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
  late String _selectedTieColor;
  late final TextEditingController _eartagController;
  late final TextEditingController _farmNumberController;
  late final TextEditingController _individualNumberController;
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
    _farmNumberController = TextEditingController();
    _individualNumberController = TextEditingController(text: '0');
    _selectedTieColor = Colors.transparent.value.toRadixString(16);
    _selectedInjuryType = injuryTypes.first;

    _ties = {...widget.ties};
    if (!_ties.keys.contains(Colors.transparent.value.toRadixString(16))) {
      _ties[Colors.transparent.value.toRadixString(16)] = null;
    }

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getDevicePosition();
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
          if (value) {Navigator.pop(context)}
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
        title: const Text('Registrer skadd sau', style: appBarTextStyle),
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
                        const RegistrationInputHeadline(title: 'Øremerke'),
                        inputFieldSpacer(),
                        Flexible(
                            child: Row(children: [
                          SizedBox(
                              width: 90,
                              child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller: _eartagController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder()))),
                          const SizedBox(width: 10),
                          SizedBox(
                              width: 120,
                              child: TextFormField(
                                  // TODO: validering
                                  textAlign: TextAlign.center,
                                  controller: _farmNumberController,
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
                                  textAlign: TextAlign.center,
                                  controller: _individualNumberController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(
                                      labelText: 'ID-nr',
                                      border: OutlineInputBorder())))
                        ])),
                        inputFieldSpacer(),
                        Row(
                          children: [
                            const SizedBox(
                                width: 115,
                                child:
                                    RegistrationInputHeadline(title: 'Slips')),
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
                        Row(children: [
                          const SizedBox(
                              width: 80,
                              child: RegistrationInputHeadline(title: 'Skade')),
                          const SizedBox(width: 15),
                          DropdownButton(
                              alignment: Alignment.centerRight,
                              iconSize: dropdownArrowSize,
                              value: _selectedInjuryType,
                              items: injuryTypes
                                  .map<DropdownMenuItem<String>>(
                                      (String type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(
                                            type,
                                            style: dropDownTextStyle,
                                          )))
                                  .toList(),
                              onChanged: (String? newType) {
                                if (_selectedInjuryType != newType!) {
                                  setState(() {
                                    _selectedInjuryType = newType;
                                  });
                                }
                              })
                        ]),
                        const SizedBox(height: 8),
                      ],
                    ))),
      ),
    ));
  }
}

class RegistrationInputHeadline extends StatelessWidget {
  const RegistrationInputHeadline({required this.title, Key? key})
      : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: registrationFieldHeadlineTextStyle));
  }
}

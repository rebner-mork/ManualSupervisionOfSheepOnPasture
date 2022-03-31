import 'package:app/utils/constants.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/widgets/dropdown_icon.dart';
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
  late Color _tieColor;
  late final TextEditingController _eartagController;
  late Map<String, int?> _ties;

  @override
  void initState() {
    super.initState();

    _eartagController = TextEditingController();
    _tieColor = Colors
        .transparent; //Color(int.parse(widget.ties.keys.first, radix: 16));

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

  void _onColorChanged(Color newColor) {
    //_helpText = '';

    if (newColor != _tieColor) {
      setState(() {
        _tieColor = newColor;
        //_tieColor = newColor;
        //_tieColors[index] = newColor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Form(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrer skadd sau'),
          leading: BackButton(onPressed: _backButtonPressed),
        ),
        body: _isLoading
            ? const LoadingData()
            : Center(
                child: Column(
                children: [
                  appbarBodySpacer(),
                  inputDividerWithHeadline('Øremerke-ID'),
                  Flexible(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        const Text(
                          'MT-NO',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
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
                            ))
                      ])),
                  inputDividerWithHeadline('Slips'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        colorValueToStringGui[_tieColor.value]!,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                          height: 55,
                          width: 90,
                          child: DropdownButton<DropdownIcon>(
                              iconSize: 32,
                              value: DropdownIcon(
                                  FontAwesome5.black_tie, _tieColor),
                              items: _ties.keys
                                  .map((String colorString) =>
                                      DropdownMenuItem<DropdownIcon>(
                                          value: DropdownIcon(
                                              FontAwesome5.black_tie,
                                              Color(int.parse(colorString,
                                                  radix: 16))),
                                          child: DropdownIcon(
                                                  FontAwesome5.black_tie,
                                                  Color(int.parse(colorString,
                                                      radix: 16)))
                                              .icon))
                                  .toList(),
                              onChanged: (DropdownIcon? newIcon) {
                                _onColorChanged(newIcon!.icon.color!);
                              })),
                    ],
                  )
                ],
              )),
      ),
    ));
  }
}

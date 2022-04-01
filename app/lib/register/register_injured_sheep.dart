import 'package:app/register/registration_input_headline.dart';
import 'package:app/register/tie_dropdown_item.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/field_validation.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/map_utils.dart' as map_utils;

const double leftMargin = 40;

class RegisterInjuredSheep extends StatefulWidget {
  const RegisterInjuredSheep({required this.ties, Key? key}) : super(key: key);

  final Map<String, int?> ties;

  @override
  State<RegisterInjuredSheep> createState() => _RegisterInjuredSheepState();
}

class _RegisterInjuredSheepState extends State<RegisterInjuredSheep> {
  bool _isLoading = true;
  late LatLng _devicePosition;
  bool _isModerate = true;
  bool _isSevere = false;

  late final TextEditingController _countryCodeController;
  final TextEditingController _farmNumberController = TextEditingController();
  late final TextEditingController _individualNumberController;
  final TextEditingController _noteController = TextEditingController();

  late String _selectedTieColor;
  late Map<String, int?> _ties;

  late String _selectedInjuryType;
  static const List<String> injuryTypes = [
    'Annen',
    'Beinskade',
    'Hodeskade',
    'Blodutredning'
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _countryCodeController = TextEditingController(text: 'MT-NO');
    _individualNumberController = TextEditingController();
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
          key: _formKey,
          onWillPop: _onWillPop,
          child: _isLoading
              ? const LoadingData()
              : SingleChildScrollView(
                  child: SizedBox(
                      height: 655,
                      child: Container(
                          margin: const EdgeInsets.only(left: leftMargin),
                          child: Column(
                            children: [
                              appbarBodySpacer(),
                              const RegistrationInputHeadline(
                                  title: 'Øremerke'),
                              inputFieldSpacer(),
                              Row(children: [
                                SizedBox(
                                    width: 97,
                                    height: textFormFieldHeight,
                                    child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: _countryCodeController,
                                        style: const TextStyle(fontSize: 18),
                                        validator: (_) =>
                                            validateEartagCountryCode(
                                                _countryCodeController.text),
                                        decoration: InputDecoration(
                                            labelText: 'Landskode',
                                            labelStyle: TextStyle(
                                                fontSize: _countryCodeController
                                                        .text.isEmpty
                                                    ? 13
                                                    : 18),
                                            border:
                                                const OutlineInputBorder()))),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 120,
                                    height: textFormFieldHeight,
                                    child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: _farmNumberController,
                                        style: const TextStyle(fontSize: 18),
                                        validator: (_) =>
                                            validateEartagFarmNumber(
                                                _farmNumberController.text),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        decoration: const InputDecoration(
                                            labelText: 'Gård',
                                            border: OutlineInputBorder()))),
                                const SizedBox(width: 10),
                                SizedBox(
                                    width: 90,
                                    height: textFormFieldHeight,
                                    child: TextFormField(
                                        validator: (_) =>
                                            validateEartagIndividualNumber(
                                                _individualNumberController
                                                    .text),
                                        textAlign: TextAlign.center,
                                        controller: _individualNumberController,
                                        style: const TextStyle(fontSize: 18),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(),
                                        decoration: const InputDecoration(
                                            labelText: 'Individ',
                                            border: OutlineInputBorder())))
                              ]),
                              const RegistrationInputHeadline(title: 'Slips'),
                              inputFieldSpacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        width: 205,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(4))),
                                            child: DropdownButton<String>(
                                              underline: const SizedBox(),
                                              isExpanded: true,
                                              itemHeight: 60,
                                              iconSize: dropdownArrowSize,
                                              value: _selectedTieColor,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedTieColor = newValue!;
                                                });
                                              },
                                              items: _ties.keys
                                                  .map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String colorHex) =>
                                                          DropdownMenuItem(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            value: colorHex,
                                                            child:
                                                                TieDropDownItem(
                                                              colorHex:
                                                                  colorHex,
                                                            ),
                                                          ))
                                                  .toList(),
                                            ))),
                                    const SizedBox(width: 40),
                                  ]),
                              inputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Skade'),
                              inputFieldSpacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4))),
                                        child: DropdownButton(
                                            itemHeight: 60,
                                            underline: const SizedBox(),
                                            alignment: Alignment.center,
                                            iconSize: dropdownArrowSize,
                                            value: _selectedInjuryType,
                                            items: injuryTypes
                                                .map<DropdownMenuItem<String>>(
                                                    (String type) =>
                                                        DropdownMenuItem(
                                                            value: type,
                                                            child: Text(
                                                              type,
                                                              style:
                                                                  dropDownTextStyle,
                                                            )))
                                                .toList(),
                                            onChanged: (String? newType) {
                                              if (_selectedInjuryType !=
                                                  newType!) {
                                                setState(() {
                                                  _selectedInjuryType = newType;
                                                });
                                              }
                                            })),
                                    const SizedBox(width: leftMargin),
                                  ]),
                              inputFieldSpacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Ink(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4))),
                                      width: 235,
                                      height: 60,
                                      child: Row(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isModerate = true;
                                                  _isSevere = false;
                                                });
                                              },
                                              child: Container(
                                                  color: _isModerate
                                                      ? Colors.green
                                                      : null,
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 115,
                                                          maxHeight: 60),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Moderat',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                _isModerate
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal),
                                                      )))),
                                          VerticalDivider(
                                            width: 3,
                                            thickness: 1,
                                            indent: 7,
                                            endIndent: 7,
                                            color: Colors.grey.shade600,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _isSevere = true;
                                                  _isModerate = false;
                                                });
                                              },
                                              child: Container(
                                                  color: _isSevere
                                                      ? Colors.green
                                                      : null,
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxWidth: 115,
                                                          maxHeight: 60),
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        'Alvorlig',
                                                        style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: _isSevere
                                                                ? FontWeight
                                                                    .bold
                                                                : FontWeight
                                                                    .normal),
                                                      ))))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: leftMargin),
                                  ]),
                              inputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Notat'),
                              inputFieldSpacer(),
                              Container(
                                  margin:
                                      const EdgeInsets.only(right: leftMargin),
                                  child: TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      maxLines: 3,
                                      controller: _noteController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder())))
                            ],
                          )))),
        ),
        floatingActionButton: _isLoading
            ? null
            : completeRegistrationButton(context, _registerInjuredSheep),
        floatingActionButtonLocation:
            MediaQuery.of(context).viewInsets.bottom == 0
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void _registerInjuredSheep() {
    if (_formKey.currentState!.validate()) {
      /*Map<String, Object> data = {};
    data.addAll(gatherRegisteredData(_textControllers));
    data['type] = 'injuredSheep'
    data['timestamp'] = DateTime.now();
    data['devicePosition'] = {
      'latitude': _devicePosition.latitude,
      'longitude': _devicePosition.longitude
    };
    data['registrationPosition'] = {
      'latitude': widget.sheepPosition.latitude,
      'longitude': widget.sheepPosition.longitude
    };

    if (widget.onCompletedSuccessfully != null) {
      widget.onCompletedSuccessfully!(data);
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }*/
    }
  }
}

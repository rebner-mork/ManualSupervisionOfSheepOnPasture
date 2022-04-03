import 'package:app/register/register_page.dart';
import 'package:app/register/widgets/eartag_input.dart';
import 'package:app/register/widgets/note_form_field.dart';
import 'package:app/register/widgets/registration_input_headline.dart';
import 'package:app/register/widgets/tie_dropdown.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/map_utils.dart' as map_utils;

const double leftMargin = 40;
const List<String> injuryTypes = [
  'Annen',
  'Beinskade',
  'Hodeskade',
  'Blodutredning'
];

class RegisterInjuredSheep extends StatefulWidget {
  const RegisterInjuredSheep(
      {required this.ties,
      required this.sheepPosition,
      required this.onCompletedSuccessfully,
      this.onWillPop,
      Key? key})
      : super(key: key);

  final Map<String, int?> ties;
  final LatLng sheepPosition;

  final ValueChanged<Map<String, Object>>? onCompletedSuccessfully;
  final VoidCallback? onWillPop;

  @override
  State<RegisterInjuredSheep> createState() => _registerState();
}

class _registerState extends State<RegisterInjuredSheep> with RegisterPage {
  bool _isLoading = true;
  late LatLng _devicePosition;
  bool _isModerate = true;
  bool _isSevere = false;
  bool _isValidationActivated = false;

  late final TextEditingController _countryCodeController;
  final TextEditingController _farmNumberController = TextEditingController();
  late final TextEditingController _individualNumberController;
  final TextEditingController _noteController = TextEditingController();

  late String _selectedTieColor;
  late Map<String, int?> _ties;

  late String _selectedInjuryType;

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
      getDevicePosition();
    });
  }

  @override
  Future<void> getDevicePosition() async {
    _devicePosition = await map_utils.getDevicePosition();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrer skadd sau', style: appBarTextStyle),
          leading: BackButton(
              onPressed: () => backButtonPressed(context, widget.onWillPop)),
        ),
        body: Form(
          key: _formKey,
          onWillPop: () => onWillPop(context, widget.onWillPop),
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
                              EartagInput(
                                formKey: _formKey,
                                countryCodeController: _countryCodeController,
                                farmNumberController: _farmNumberController,
                                individualNumberController:
                                    _individualNumberController,
                                isValidationActivated: _isValidationActivated,
                              ),
                              const RegistrationInputHeadline(title: 'Slips'),
                              inputFieldSpacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 205,
                                      child: TieDropdownButton(
                                          selectedTieColor: _selectedTieColor,
                                          tieColors: _ties.keys.toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedTieColor = newValue!;
                                            });
                                          }),
                                    ),
                                    const SizedBox(width: 40),
                                  ]),
                              inputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Skade'),
                              inputFieldSpacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InjuryTypeDropdownButton(
                                        selectedInjuryType: _selectedInjuryType,
                                        onChanged: (String? newType) {
                                          if (_selectedInjuryType != newType!) {
                                            setState(() {
                                              _selectedInjuryType = newType;
                                            });
                                          }
                                        }),
                                    const SizedBox(width: leftMargin),
                                  ]),
                              inputFieldSpacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ModerateSevereToggle(
                                      isModerate: _isModerate,
                                      isSevere: _isSevere,
                                      onTapModerate: () {
                                        setState(() {
                                          _isModerate = true;
                                          _isSevere = false;
                                        });
                                      },
                                      onTapSevere: () {
                                        setState(() {
                                          _isSevere = true;
                                          _isModerate = false;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: leftMargin),
                                  ]),
                              inputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Notat'),
                              inputFieldSpacer(),
                              NoteFormField(
                                  textController: _noteController,
                                  rightMargin: leftMargin),
                            ],
                          )))),
        ),
        floatingActionButton:
            _isLoading ? null : completeRegistrationButton(context, register),
        floatingActionButtonLocation:
            MediaQuery.of(context).viewInsets.bottom == 0
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  @override
  void register() {
    _isValidationActivated = true;
    if (_formKey.currentState!.validate()) {
      Map<String, Object> data = {
        ...getMetaRegistrationData(
            type: 'injuredSheep',
            devicePosition: _devicePosition,
            registrationPosition: widget.sheepPosition),
        'eartag': _countryCodeController.text +
            '-' +
            _farmNumberController.text +
            '-' +
            _individualNumberController.text,
        'tieColor': _selectedTieColor,
        'injuryType': _selectedInjuryType,
        'severity': _isModerate ? 'moderat' : 'alvorlig',
        'note': _noteController.text
      };

      if (widget.onCompletedSuccessfully != null) {
        widget.onCompletedSuccessfully!(data);
      }
      if (widget.onWillPop != null) {
        widget.onWillPop!();
      }
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }
}

class InjuryTypeDropdownButton extends StatelessWidget {
  const InjuryTypeDropdownButton(
      {required this.selectedInjuryType, required this.onChanged, Key? key})
      : super(key: key);

  final String selectedInjuryType;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: DropdownButton(
            itemHeight: 60,
            underline: const SizedBox(),
            alignment: Alignment.center,
            iconSize: dropdownArrowSize,
            value: selectedInjuryType,
            items: injuryTypes
                .map<DropdownMenuItem<String>>(
                    (String type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: dropDownTextStyle,
                        )))
                .toList(),
            onChanged: onChanged));
  }
}

class ModerateSevereToggle extends StatelessWidget {
  const ModerateSevereToggle(
      {required this.isModerate,
      required this.isSevere,
      required this.onTapModerate,
      required this.onTapSevere,
      Key? key})
      : super(key: key);

  final bool isModerate;
  final bool isSevere;
  final VoidCallback onTapModerate;
  final VoidCallback onTapSevere;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      width: 235,
      height: 60,
      child: Row(
        children: [
          InkWell(
              onTap: onTapModerate,
              child: Container(
                  color: isModerate ? Colors.green : null,
                  constraints:
                      const BoxConstraints(maxWidth: 115, maxHeight: 60),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Moderat',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: isModerate
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )))),
          VerticalDivider(
            width: 3,
            thickness: 1,
            indent: 7,
            endIndent: 7,
            color: Colors.grey.shade600,
          ),
          InkWell(
              onTap: onTapSevere,
              child: Container(
                  color: isSevere ? Colors.green : null,
                  constraints:
                      const BoxConstraints(maxWidth: 115, maxHeight: 60),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Alvorlig',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                isSevere ? FontWeight.bold : FontWeight.normal),
                      ))))
        ],
      ),
    );
  }
}

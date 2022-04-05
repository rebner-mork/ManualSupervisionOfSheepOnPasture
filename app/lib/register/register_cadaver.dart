import 'package:app/register/widgets/eartag_input.dart';
import 'package:app/register/widgets/note_form_field.dart';
import 'package:app/register/widgets/registration_input_headline.dart';
import 'package:app/register/widgets/tie_dropdown.dart';
import 'package:app/utils/camera/camera_input_button.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:flutter/material.dart';
import 'package:app/register/register_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/utils/map_utils.dart' as map_utils;
import 'package:app/utils/styles.dart';

class RegisterCadaver extends StatefulWidget {
  const RegisterCadaver(
      {Key? key,
      required this.cadaverPosition,
      required this.ties,
      required this.onCompletedSuccessfully,
      this.onWillPop})
      : super(key: key);

  static const String route = 'register-cadaver';

  final Map<String, int?> ties;
  final LatLng cadaverPosition;

  final VoidCallback? onWillPop;
  final ValueChanged<Map<String, Object>>? onCompletedSuccessfully;

  final double leftMargin = 40;

  @override
  State<RegisterCadaver> createState() => _RegisterCadaverState();
}

class _RegisterCadaverState extends State<RegisterCadaver> with RegisterPage {
  late String dropdownValue = widget.ties.keys.first;

  final _formKey = GlobalKey<FormState>();

  late LatLng _devicePosition;

  bool _isLoading = true;
  bool _isValidationActivated = false;

  late String _selectedTieColor;
  late Map<String, int?> _ties;

  List<String> photoPaths = ["", "", ""];

  late final TextEditingController _countryCodeController;
  final TextEditingController _farmNumberController = TextEditingController();
  late final TextEditingController _individualNumberController;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _countryCodeController = TextEditingController(text: 'MT-NO');
    _individualNumberController = TextEditingController();
    _selectedTieColor = Colors.transparent.value.toRadixString(16);

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
          title: const Text('Registrer kadaver', style: appBarTextStyle),
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
                          margin: EdgeInsets.only(left: widget.leftMargin),
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
                              const RegistrationInputHeadline(title: 'Notat'),
                              inputFieldSpacer(),
                              NoteFormField(
                                  textController: _noteController,
                                  rightMargin: widget.leftMargin),
                              inputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Bilder'),
                              inputFieldSpacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CameraInputButton(
                                      onPhotoChanged: (photoPath) {
                                    photoPaths[0] = photoPath;
                                  }),
                                  const SizedBox(width: 10),
                                  CameraInputButton(
                                    onPhotoChanged: (photoPath) =>
                                        photoPaths[1] = photoPath,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CameraInputButton(
                                    onPhotoChanged: (photoPath) =>
                                        photoPaths[2] = photoPath,
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              )
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
      photoPaths.removeWhere((element) => element == "");

      Map<String, Object> data = {
        ...getMetaRegistrationData(
            type: 'cadaver',
            devicePosition: _devicePosition,
            registrationPosition: widget.cadaverPosition),
        'eartag': _countryCodeController.text +
            '-' +
            _farmNumberController.text +
            '-' +
            _individualNumberController.text,
        'note': _noteController.text,
        'photos': photoPaths
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

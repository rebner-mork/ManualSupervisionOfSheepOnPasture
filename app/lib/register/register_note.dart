import 'package:app/register/register_page.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/map_utils.dart' as map_utils;

class RegisterNote extends StatefulWidget {
  const RegisterNote(
      {required this.notePosition,
      required this.onCompletedSuccessfully,
      this.onWillPop,
      Key? key})
      : super(key: key);

  final LatLng notePosition;
  final ValueChanged<Map<String, Object>>? onCompletedSuccessfully;
  final VoidCallback? onWillPop;

  @override
  State<RegisterNote> createState() => _RegisterNoteState();
}

class _RegisterNoteState extends State<RegisterNote> with RegisterPage {
  bool _isLoading = true;
  late LatLng _devicePosition;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

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
  void register() {
    /*_isValidationActivated = true;
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
        'severity': _isModerate ? 'Moderat' : 'Alvorlig',
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
    }*/
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Registrer notat', style: appBarTextStyle),
              leading: BackButton(
                  onPressed: () =>
                      backButtonPressed(context, widget.onWillPop)),
            ),
            body: WillPopScope(
                onWillPop: () => onWillPop(context, widget.onWillPop),
                child: _isLoading ? const Text('hei') : const Text('hade'))));
  }
}

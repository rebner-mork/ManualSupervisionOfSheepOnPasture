import 'package:app/register/widgets/note_form_field.dart';
import 'package:app/register/widgets/registration_input_headline.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:flutter/material.dart';
import 'package:app/register/register_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/utils/map_utils.dart' as map_utils;
import 'package:app/utils/styles.dart';
import 'package:app/widgets/toggle_button_group.dart';

class RegisterPredator extends StatefulWidget {
  const RegisterPredator(
      {Key? key,
      required this.predatorPosition,
      required this.onCompletedSuccessfully,
      this.onWillPop})
      : super(key: key);

  final LatLng predatorPosition;

  final VoidCallback? onWillPop;
  final ValueChanged<Map<String, Object>>? onCompletedSuccessfully;

  final double leftMargin = 40;

  @override
  State<RegisterPredator> createState() => _RegisterPredatorState();
}

class _RegisterPredatorState extends State<RegisterPredator> with RegisterPage {
  late LatLng _devicePosition;

  bool _isLoading = true;

  final TextEditingController _noteController = TextEditingController();

  String species = "";
  int quantity = 0;

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
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registrer rovdyr', style: appBarTextStyle),
          leading: BackButton(
              onPressed: () => backButtonPressed(context, widget.onWillPop)),
        ),
        body: Form(
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
                              const AppbarBodySpacer(),
                              const RegistrationInputHeadline(title: 'Art'),
                              const InputFieldSpacer(),
                              ToggleButtonGroup(
                                valueLabelPairs: const {
                                  "Bjørn": "bear",
                                  "Ulv": "wolf",
                                  "Jerv": "wolverine",
                                  "Gaupe": "lynx"
                                },
                                preselectedItem: "Bjørn",
                                itemsPerRow: 2,
                                itemSize: const Size(160, 100),
                                fontSize: 30,
                                onValueChanged: (value) => species = value,
                              ),
                              const InputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Antall'),
                              const InputFieldSpacer(),
                              ToggleButtonGroup(
                                valueLabelPairs: const {"1": 1, "2": 2, "3": 3},
                                preselectedItem: "1",
                                onValueChanged: (value) => quantity = value,
                              ),
                              const InputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Notat'),
                              const InputFieldSpacer(),
                              NoteFormField(
                                  textController: _noteController,
                                  rightMargin: widget.leftMargin),
                              const InputFieldSpacer(),
                            ],
                          )))),
        ),
        floatingActionButton: _isLoading
            ? null
            : CompleteRegistrationButton(context: context, onPressed: register),
        floatingActionButtonLocation:
            MediaQuery.of(context).viewInsets.bottom == 0
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  @override
  void register() {
    Map<String, Object> data = {
      ...getMetaRegistrationData(
          type: 'predator',
          devicePosition: _devicePosition,
          registrationPosition: widget.predatorPosition),
      'species': species,
      'quantity': quantity,
      'note': _noteController.text,
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

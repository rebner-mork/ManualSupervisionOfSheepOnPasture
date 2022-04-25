import 'package:app/register/widgets/note_form_field.dart';
import 'package:app/register/widgets/registration_input_headline.dart';
import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:flutter/material.dart';
import 'package:app/register/register_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:app/utils/map_utils.dart' as map_utils;
import 'package:app/utils/styles.dart';

class RegisterPredator extends StatefulWidget {
  const RegisterPredator(
      {Key? key,
      required this.predatorPosition,
      required this.onCompletedSuccessfully,
      this.onWillPop})
      : super(key: key);

  static const String route = 'register-predator';

  final LatLng predatorPosition;

  final VoidCallback? onWillPop;
  final ValueChanged<Map<String, Object>>? onCompletedSuccessfully;

  final double leftMargin = 40;

  @override
  State<RegisterPredator> createState() => _RegisterPredatorState();
}

class _RegisterPredatorState extends State<RegisterPredator> with RegisterPage {
  final _formKey = GlobalKey<FormState>();

  late LatLng _devicePosition;

  bool _isLoading = true;

  final TextEditingController _noteController = TextEditingController();

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
                              const RegistrationInputHeadline(title: 'Art'),
                              inputFieldSpacer(),
                              // Widget herOutlineButton
                              const RegistrationInputHeadline(title: 'Antall'),
                              inputFieldSpacer(),
                              ToggleButtonGroup(
                                valueLabelParis: const {"1": 1, "2": 2, "3": 3},
                                onValueChanged: (value) => quantity = value,
                              ),
                              // Widget her
                              inputFieldSpacer(),
                              const RegistrationInputHeadline(title: 'Notat'),
                              inputFieldSpacer(),
                              NoteFormField(
                                  textController: _noteController,
                                  rightMargin: widget.leftMargin),
                              inputFieldSpacer(),
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
    if (_formKey.currentState!.validate()) {
      Map<String, Object> data = {
        ...getMetaRegistrationData(
            type: 'predator',
            devicePosition: _devicePosition,
            registrationPosition: widget.predatorPosition),
        'species': 'foo',
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
}

class ToggleButtonGroup extends StatefulWidget {
  ToggleButtonGroup(
      {Key? key, required this.valueLabelParis, this.onValueChanged})
      : super(key: key);

  final Map<String, dynamic> valueLabelParis;

  final ValueChanged<dynamic>? onValueChanged;
  @override
  State<ToggleButtonGroup> createState() => _ToggleButtonGroupState();
}

class _ToggleButtonGroupState extends State<ToggleButtonGroup> {
  //
  late ValueNotifier<List<bool>> isSelected = ValueNotifier<List<bool>>(
      List.filled(widget.valueLabelParis.length, false));

  dynamic value;

  final ButtonStyle isSelectedStyle = OutlinedButton.styleFrom(
      backgroundColor: Colors.green, fixedSize: const Size(50, 50));

  final ButtonStyle isNotSelectedStyle = OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent, fixedSize: const Size(40, 40));

  List<Widget> toggleButtons = [];

  List<Widget> generateToggleButtons() {
    List<Widget> toggleButtons = [];

    int index = 0;

    for (String key in widget.valueLabelParis.keys) {
      toggleButtons.add(OutlinedButton(
        onPressed: () {
          value = widget.valueLabelParis[key];
          setState(() {
            isSelected = ValueNotifier<List<bool>>(
                List.filled(widget.valueLabelParis.length, false));
            isSelected
                    .value[widget.valueLabelParis.keys.toList().indexOf(key)] =
                true;
          });
          if (widget.onValueChanged != null) {
            //widget.!onValueChanged(value);
          }
        },
        child: Text(
          key,
        ),
        style:
            isSelected.value[widget.valueLabelParis.keys.toList().indexOf(key)]
                ? isSelectedStyle
                : isNotSelectedStyle,
      ));

      if (index != widget.valueLabelParis.length - 1) {
        toggleButtons.add(const SizedBox(width: 10));
        index++;
      }
    }

    return toggleButtons;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<bool>>(
        valueListenable: isSelected,
        builder: (context, value, child) => Row(
              children: [...generateToggleButtons()],
            ));
  }
}

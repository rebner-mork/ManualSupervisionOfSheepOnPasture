import 'dart:ui';

import 'package:app/providers/settings_provider.dart';
import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

InputDecoration customInputDecoration(String labelText, IconData icon,
    {bool passwordField = false,
    bool isVisible = false,
    void Function()? onPressed}) {
  return InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
      suffixIcon: passwordField
          ? IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20),
              color: isVisible ? Colors.green : Colors.grey,
              onPressed: onPressed)
          : null);
}

SizedBox inputFieldSpacer() {
  return const SizedBox(height: 18);
}

SizedBox appbarBodySpacer() {
  return const SizedBox(height: 20);
}

const double defaultIconSize = 30;

class LoadingData extends StatefulWidget {
  const LoadingData({this.text = 'Laster inn...', Key? key}) : super(key: key);

  final String text;

  @override
  State<LoadingData> createState() => _LoadingDataState();
}

class _LoadingDataState extends State<LoadingData>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    _animationController.reset();

    _colorTween = _animationController.drive(
        ColorTween(begin: Colors.green.shade700, end: Colors.green.shade300));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          height: 48,
          width: 48,
          child: CircularProgressIndicator(
            valueColor: _colorTween,
            strokeWidth: 6,
          )),
      const SizedBox(height: 10),
      Text(
        widget.text,
        style: feedbackTextStyle,
      )
    ]));
  }
}

Row inputRow(String text, TextEditingController controller, IconData iconData,
    Color color,
    {double iconSize = defaultIconSize,
    ScrollController? scrollController,
    GlobalKey? key}) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Flexible(
        flex: 5,
        child: Container(
            width: defaultIconSize + 3,
            color: color == Colors.white
                ? Colors.grey.shade400
                : Colors.transparent,
            child: Icon(
              iconData,
              color: color,
              size: iconSize,
            ))),
    const Spacer(),
    Flexible(
        flex: 10,
        child: Container(
            constraints: const BoxConstraints(minWidth: 100),
            child: Text(
              text,
              style: const TextStyle(fontSize: 19),
            ))),
    const Spacer(),
    Flexible(
        flex: 20,
        child: Container(
            constraints: const BoxConstraints(maxWidth: 70),
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: controller,
              onFieldSubmitted: (_) => {
                if (scrollController != null && key != null)
                  scrollToKey(scrollController, key),
              },
              decoration: const InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              ),
            )))
  ]);
}

Column inputDividerWithHeadline(String headline, [GlobalKey? key]) {
  return Column(key: key, children: [
    const SizedBox(height: 10),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Flexible(
          child: Divider(
        thickness: 3,
        color: Colors.grey,
        endIndent: 5,
      )),
      Flexible(
          flex: 5,
          child: Text(
            headline,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          )),
      const Flexible(
          child: Divider(
        thickness: 3,
        color: Colors.grey,
        indent: 5,
      ))
    ]),
    const SizedBox(height: 10),
  ]);
}

Future<bool> cancelRegistrationDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: AlertDialog(
              title: const Text("Avbryte registrering?"),
              content: const Text('Data i registreringen vil gå tapt.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Ja, avbryt')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Nei, fortsett'))
              ],
            ));
      });
}

BackdropFilter speechNotEnabledDialog(
    BuildContext context, MaterialPageRoute route) {
  return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        title: const Text("Taleregistrering kan ikke brukes"),
        content: const Text(
            'Enheten er ikke satt opp til å bruke taleregistrering.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop('dialog');
                Navigator.of(context).pushReplacement(route);
              },
              child: const Text('Til manuell registrering')),
        ],
      ));
}

FloatingActionButton completeRegistrationButton(
    BuildContext context, void Function() onPressed) {
  return MediaQuery.of(context).viewInsets.bottom == 0
      ? FloatingActionButton.extended(
          heroTag: 'completeOralRegistrationButton',
          onPressed: onPressed,
          label: const Text('Fullfør registrering',
              style: TextStyle(fontSize: 19)))
      : FloatingActionButton(
          onPressed: onPressed,
          child: const Icon(
            Icons.check,
            size: 35,
          ));
}

FloatingActionButton startDialogButton(void Function() onPressed) {
  return FloatingActionButton(
    heroTag: 'startDialogButton',
    onPressed: onPressed,
    child: const Icon(Icons.mic, size: 30),
  );
}

class SettingsIcon extends StatelessWidget {
  const SettingsIcon({required this.iconSize, Key? key}) : super(key: key);

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.settings,
      color: Colors.black,
      size: iconSize,
    );
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        clipBehavior: Clip.none,
        child: SingleChildScrollView(
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 6, top: 26, right: 6, bottom: 26),
              child: ListBody(children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Innstillinger',
                      style: settingsHeadlineTextStyle,
                      textAlign: TextAlign.center,
                    )),
                ...speechSettings(context)
              ])),
        ));
  }
}

List<Widget> speechSettings(BuildContext context) {
  return [
    Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          'Tale',
          style: settingsHeadlineTwoTextStyle,
          textAlign: TextAlign.center,
        )),
    ...Provider.of<SettingsProvider>(context).sttAvailable == null
        ? [
            const Text(
              'Blir tilgjengelig under oppsynstur',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            )
          ]
        : Provider.of<SettingsProvider>(context).sttAvailable!
            ? <Widget>[
                SettingsSwitchListTile(
                  tooltipText: 'Taleregistrerings-dialog starter automatisk',
                  settingText: 'Autostart dialog',
                  value: Provider.of<SettingsProvider>(context).autoDialog,
                  onChanged: (_) {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .toggleAutoDialog();
                  },
                  margin: const EdgeInsets.only(left: 15),
                ),
                SettingsSwitchListTile(
                    tooltipText: 'Det som ble tolket leses tilbake',
                    settingText: 'Les tilbake',
                    value: Provider.of<SettingsProvider>(context).readBack,
                    onChanged: (_) {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .toggleReadBack();
                    },
                    margin: const EdgeInsets.only(left: 35))
              ]
            : <Widget>[
                Row(children: [
                  Tooltip(
                      message:
                          'Enheten er ikke konfigurert for offline taleregistrering. '
                          'Last ned språkpakken engelsk(US) på enhetens innstillinger og restart appen. '
                          'Samsung-brukere må muligens skru av Samsung voice typing.',
                      preferBelow: true,
                      textStyle:
                          const TextStyle(fontSize: 16, color: Colors.white),
                      child: Icon(
                        Icons.info,
                        size: 36,
                        color: Colors.grey.shade600,
                      ),
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: const Duration(seconds: 30)),
                  Text(
                    'Tale-til-tekst ikke konfigurert',
                    style: settingsTextStyle,
                    textAlign: TextAlign.center,
                  )
                ]),
              ]
  ];
}

class SettingsSwitchListTile extends StatelessWidget {
  const SettingsSwitchListTile(
      {required this.tooltipText,
      required this.settingText,
      required this.value,
      required this.onChanged,
      this.margin,
      Key? key})
      : super(key: key);

  final String settingText;
  final String tooltipText;
  final bool value;
  final Function(bool) onChanged;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        title: Text(
          settingText,
          style: settingsTextStyle,
        ),
        activeColor: Colors.green,
        secondary: Tooltip(
            message: tooltipText,
            preferBelow: true,
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
            margin: margin,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Icon(
              Icons.info,
              size: 38,
              color: Colors.grey.shade600,
            ),
            triggerMode: TooltipTriggerMode.tap),
        value: value,
        onChanged: onChanged);
  }
}

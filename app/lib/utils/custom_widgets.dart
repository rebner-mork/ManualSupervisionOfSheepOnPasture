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

Row inputRow(String text, TextEditingController controller, IconData iconData,
    Color color,
    {double iconSize = defaultIconSize,
    int fieldAmount = 1,
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

BackdropFilter cancelRegistrationDialog(BuildContext context) {
  return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: AlertDialog(
        title: const Text("Avbryte registrering?"),
        content: const Text('Data i registreringen vil gå tapt.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop('dialog');
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ja, avbryt')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop('dialog');
              },
              child: const Text('Nei, fortsett'))
        ],
      ));
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

class Sheepometer extends StatefulWidget {
  const Sheepometer(this.sheepAmount, {Key? key}) : super(key: key);

  final int sheepAmount;

  @override
  State<Sheepometer> createState() => _SheepometerState();
}

class _SheepometerState extends State<Sheepometer> {
  Color color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTapDown: (_) {
          setState(() {
            color = Colors.green.shade700;
          });
        },
        onTap: () {
          setState(() {
            color = Colors.green;
          });
        },
        child: Container(
            height: circularMapButtonSize.height,
            width: 62 +
                textSize(widget.sheepAmount.toString(),
                        circularMapButtonTextStyle)
                    .width,
            decoration: color == Colors.green
                ? circularMapButtonDecoration
                : circularMapButtonDecorationPressed,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Image(
                  image: AssetImage('images/sheep.png'), width: 42, height: 42),
              Text(widget.sheepAmount.toString(),
                  style: circularMapButtonTextStyle),
              const SizedBox(
                width: 2,
              )
            ])));
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: circularMapButtonSize.width,
        height: circularMapButtonSize.height,
        decoration: circularMapButtonDecoration,
        child: const SettingsIconButton());
  }
}

class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.settings,
            color: Colors.black,
            size: 42,
          ),
          onPressed: () {
            showDialog(
                context: context, builder: (_) => const SettingsDialog());
          },
        ));
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
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 16),
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(top: 26, bottom: 10),
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
            )));
    /*return SimpleDialog(
        title: Text(
          'Innstillinger',
          style: settingsHeadlineTextStyle,
          textAlign: TextAlign.center,
        ),
        children: [...speechSettings(context)]);*/
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
                  tooltipText:
                      'PÅ: Taleregistrering starter automatisk\nAV: Taleregistrering startes med knapp', // 'Taleregistrerings-dialog starter automatisk'
                  settingText: 'Autostart dialog',
                  value: Provider.of<SettingsProvider>(context).autoDialog,
                  onChanged: (_) {
                    Provider.of<SettingsProvider>(context, listen: false)
                        .toggleAutoDialog();
                  },
                  margin: const EdgeInsets.only(left: 34),
                ),
                SettingsSwitchListTile(
                    tooltipText:
                        'Taleassistent leser tilbake det den tolket at du sa',
                    settingText: 'Les tilbake',
                    value: Provider.of<SettingsProvider>(context).readBack,
                    onChanged: (_) {
                      Provider.of<SettingsProvider>(context, listen: false)
                          .toggleReadBack();
                    })
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
            size: 36,
            color: Colors.grey.shade600,
          ),
          triggerMode: TooltipTriggerMode.tap,
        ),
        value: value,
        onChanged: onChanged);
  }
}

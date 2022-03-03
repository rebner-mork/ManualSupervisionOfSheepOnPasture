import 'dart:ui';

import 'package:app/utils/other.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

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

class CircularMapButton extends StatelessWidget {
  const CircularMapButton({this.child, this.width, this.height, Key? key})
      : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        width: width ?? circularMapButtonSize.width,
        height: height ?? circularMapButtonSize.height,
        decoration: circularMapButtonDecoration,
        child: child);
  }
}

class SheepometerIconButton extends StatelessWidget {
  const SheepometerIconButton(this.sheepAmount, {Key? key}) : super(key: key);

  final int sheepAmount;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: IconButton(
          highlightColor: Colors.green.shade700,
          splashRadius: 42 +
              textSize(sheepAmount.toString(), circularMapButtonTextStyle)
                  .width,
          padding: EdgeInsets.zero,
          icon: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Image(
                image: AssetImage('images/sheep.png'), width: 42, height: 42),
            Text(sheepAmount.toString(), style: circularMapButtonTextStyle),
            const SizedBox(
              width: 2,
            )
          ]),
          onPressed: () {},
        ));
  }
}

class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: IconButton(
          highlightColor: Colors.green.shade700,
          splashRadius: 27,
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
    return SimpleDialog(
        title: Text(
          'Innstillinger',
          style: settingsHeadlineTextStyle,
          textAlign: TextAlign.center,
        ),
        children: [
          ListTile(
            title: Text(
              'Auto-dialog',
              style: settingsTextStyle,
            ),
            trailing: Switch(
                value: true, activeColor: Colors.green, onChanged: (_) {}),
          ),
          ListTile(
            title: Text('Les tilbake', style: settingsTextStyle),
            trailing: Switch(
                value: true, activeColor: Colors.green, onChanged: (_) {}),
          ),
          ElevatedButton(
            child: Text(
              'Nedlastede kart',
              style: buttonTextStyle,
            ),
            style: ButtonStyle(
              fixedSize:
                  MaterialStateProperty.all(Size.fromHeight(mainButtonHeight)),
            ),
            onPressed: () {},
          )
        ]);
  }
}

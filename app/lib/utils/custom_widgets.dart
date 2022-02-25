import 'dart:ui';

import 'package:app/utils/other.dart';
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

BackdropFilter speechNotEnabledDialog(BuildContext context, String route) {
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
                Navigator.of(context).pushReplacementNamed(route);
              },
              child: const Text('Til manuell registrering')),
        ],
      ));
}

FloatingActionButton completeRegistrationButton(
    BuildContext context, void Function() onPressed) {
  return MediaQuery.of(context).viewInsets.bottom == 0
      ? FloatingActionButton.extended(
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
    onPressed: onPressed,
    child: const Icon(Icons.mic, size: 30),
  );
}

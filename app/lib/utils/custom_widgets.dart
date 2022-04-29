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

class LoadingData extends StatefulWidget {
  const LoadingData(
      {this.text = 'Laster inn...', this.smallCircleOnly = false, Key? key})
      : super(key: key);

  final String text;
  final bool smallCircleOnly;

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: widget.smallCircleOnly
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: _colorTween,
                  strokeWidth: 2.5,
                ))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
    GlobalKey? key,
    GlobalKey? ownKey}) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      key: ownKey,
      children: [
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
            flex: 11,
            child: SizedBox(
                width: 115,
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

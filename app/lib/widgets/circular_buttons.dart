import 'package:app/utils/custom_widgets.dart';
import 'package:flutter/material.dart';

TextStyle circularButtonTextStyle =
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class CircularButton extends StatelessWidget {
  const CircularButton(
      {required this.child,
      required this.onPressed,
      this.width = 50,
      this.height = 50,
      Key? key})
      : super(key: key);

  final Widget child;
  final double width;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.transparent, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            boxShadow: const [BoxShadow(blurRadius: 7, offset: Offset(0, 3))]),
        child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: child,
              onPressed: onPressed,
              highlightColor: Colors.green.shade700,
              splashRadius:
                  width > height ? (width + 10) / 2 : (height + 10) / 2,
              padding: EdgeInsets.zero,
            )));
  }
}

class Sheepometer extends StatelessWidget {
  const Sheepometer(
      {required this.sheepAmount, required this.iconSize, Key? key})
      : super(key: key);

  final int sheepAmount;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image(
          image: const AssetImage('images/sheep.png'),
          width: iconSize,
          height: iconSize),
      Text(sheepAmount.toString(), style: circularButtonTextStyle),
      const SizedBox(
        width: 2,
      )
    ]);
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
          splashRadius: 24,
          padding: EdgeInsets.zero,
          icon: const SettingsIcon(iconSize: 42),
          onPressed: () {
            showDialog(
                context: context, builder: (_) => const SettingsDialog());
          },
        ));
  }
}

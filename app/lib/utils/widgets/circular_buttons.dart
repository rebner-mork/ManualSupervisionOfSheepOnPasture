import 'package:app/utils/custom_widgets.dart';
import 'package:app/utils/other.dart';
import 'package:flutter/material.dart';

TextStyle circularButtonTextStyle =
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

Size circularButtonSize = const Size(50, 50);

BoxDecoration circularButtonDecoration = BoxDecoration(
    color: Colors.green,
    border: Border.all(color: Colors.transparent, width: 0),
    borderRadius: const BorderRadius.all(Radius.circular(18)),
    boxShadow: const [BoxShadow(blurRadius: 7, offset: Offset(0, 3))]);

class CircularButton extends StatelessWidget {
  const CircularButton({this.child, this.width, this.height, Key? key})
      : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.hardEdge,
        width: width ?? circularButtonSize.width,
        height: height ?? circularButtonSize.height,
        decoration: circularButtonDecoration,
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
              textSize(sheepAmount.toString(), circularButtonTextStyle).width,
          padding: EdgeInsets.zero,
          icon: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Image(
                image: AssetImage('images/sheep.png'), width: 42, height: 42),
            Text(sheepAmount.toString(), style: circularButtonTextStyle),
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

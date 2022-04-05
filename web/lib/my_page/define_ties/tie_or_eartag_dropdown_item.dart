import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:web/utils/constants.dart';
import 'package:web/utils/styles.dart';

class TieDropDownItem extends StatelessWidget {
  TieDropDownItem({Key? key, required Color color, required bool isTie})
      : super(key: key) {
    bool isTransparent = color == Colors.transparent;
    icon = Icon(
        isTransparent
            ? Icons.disabled_by_default
            : isTie
                ? FontAwesome5.black_tie
                : Icons.local_offer,
        color: isTransparent ? Colors.grey.shade400 : color,
        size: 30);

    label = colorValueToStringGui[color.value.toRadixString(16)]!;
  }

  late final Icon icon;
  late final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 55,
                child: Text(
                  label,
                  style: dropDownTextStyle,
                ))
          ],
        ));
  }
}

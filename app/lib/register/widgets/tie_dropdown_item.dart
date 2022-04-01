import 'package:app/utils/constants.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class TieDropDownItem extends StatelessWidget {
  TieDropDownItem({Key? key, required String colorHex}) : super(key: key) {
    bool isTransparent = colorHex == '0';
    icon = Icon(
        isTransparent ? Icons.disabled_by_default : FontAwesome5.black_tie,
        color:
            isTransparent ? Colors.grey.shade400 : colorStringToColor[colorHex],
        size: 38);

    label = colorValueToStringGui[colorHex]!;
  }

  late final Icon icon;
  late final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        const SizedBox(
          width: 10,
        ),
        SizedBox(
            width: 90,
            child: Text(
              label,
              style: dropDownTextStyle,
            ))
      ],
    ));
  }
}

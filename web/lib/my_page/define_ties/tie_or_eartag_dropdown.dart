import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:web/utils/constants.dart';

class TieOrEartagDropdownButton extends StatelessWidget {
  const TieOrEartagDropdownButton(
      {required this.selectedColor,
      required this.colors,
      required this.onChanged,
      required this.isTie,
      Key? key})
      : super(key: key);

  final Color selectedColor;
  final List<Color> colors;
  final Function(Color?) onChanged;
  final bool isTie;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: DropdownButton<Color>(
          underline: const SizedBox(),
          isExpanded: true,
          itemHeight: 60,
          iconSize: dropdownArrowSize,
          value: selectedColor,
          onChanged: onChanged,
          items: colors
              .map<DropdownMenuItem<Color>>((Color color) => DropdownMenuItem(
                    alignment: Alignment.centerRight,
                    value: color,
                    child: TieDropDownItem(color: color, isTie: isTie),
                  ))
              .toList(),
        ));
  }
}

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

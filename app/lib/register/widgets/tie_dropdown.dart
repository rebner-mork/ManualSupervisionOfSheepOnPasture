import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class TieDropdownButton extends StatelessWidget {
  const TieDropdownButton(
      {required this.selectedTieColor,
      required this.tieColors,
      required this.onChanged,
      Key? key})
      : super(key: key);

  final String selectedTieColor;
  final List<String> tieColors;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(4))),
        child: DropdownButton<String>(
          underline: const SizedBox(),
          isExpanded: true,
          itemHeight: 60,
          iconSize: dropdownArrowSize,
          value: selectedTieColor,
          onChanged: onChanged,
          items: tieColors
              .map<DropdownMenuItem<String>>(
                  (String colorHex) => DropdownMenuItem(
                        alignment: Alignment.centerRight,
                        value: colorHex,
                        child: TieDropDownItem(
                          colorHex: colorHex,
                        ),
                      ))
              .toList(),
        ));
  }
}

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

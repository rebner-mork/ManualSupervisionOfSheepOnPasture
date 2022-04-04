import 'package:app/register/widgets/tie_dropdown_item.dart';
import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

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

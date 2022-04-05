import 'package:flutter/material.dart';
import 'package:web/my_page/define_ties/tie_or_eartag_dropdown_item.dart';
import 'package:web/utils/styles.dart';

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

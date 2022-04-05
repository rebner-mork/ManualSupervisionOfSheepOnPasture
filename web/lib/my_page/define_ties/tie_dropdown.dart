import 'package:flutter/material.dart';
import 'package:web/my_page/define_ties/tie_dropdown_item.dart';
import 'package:web/utils/styles.dart';

class TieDropdownButton extends StatelessWidget {
  const TieDropdownButton(
      {required this.selectedTieColor,
      required this.tieColors,
      required this.onChanged,
      Key? key})
      : super(key: key);

  final Color selectedTieColor;
  final List<Color> tieColors;
  final Function(Color?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: DropdownButton<Color>(
          underline: const SizedBox(),
          isExpanded: true,
          itemHeight: 60,
          iconSize: dropdownArrowSize,
          value: selectedTieColor,
          onChanged: onChanged,
          items: tieColors
              .map<DropdownMenuItem<Color>>((Color color) => DropdownMenuItem(
                    alignment: Alignment.centerRight,
                    value: color,
                    child: TieDropDownItem(
                      color: color,
                    ),
                  ))
              .toList(),
        ));
  }
}

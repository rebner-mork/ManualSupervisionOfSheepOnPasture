import 'package:flutter/material.dart';

class ToggleButtonGroup extends StatefulWidget {
  const ToggleButtonGroup(
      {Key? key,
      required this.valueLabelPairs,
      this.onValueChanged,
      this.preselectedItem,
      this.itemSize = const Size(100, 60),
      this.itemsPerRow,
      this.fontSize})
      : super(key: key);

  final Map<String, dynamic> valueLabelPairs;
  final String? preselectedItem;

  final ValueChanged<dynamic>? onValueChanged;

  final Size itemSize;
  final int? itemsPerRow;

  final double? fontSize;

  @override
  State<ToggleButtonGroup> createState() => _ToggleButtonGroupState();
}

class _ToggleButtonGroupState extends State<ToggleButtonGroup> {
  dynamic value;

  late ValueNotifier<List<bool>> isSelected = ValueNotifier<List<bool>>(
      List.filled(widget.valueLabelPairs.length, false));

  @override
  void initState() {
    super.initState();
    if (widget.preselectedItem != null &&
        widget.valueLabelPairs.keys.contains(widget.preselectedItem)) {
      value = widget.valueLabelPairs[widget.preselectedItem];
      isSelected.value[widget.valueLabelPairs.keys
          .toList()
          .indexOf(widget.preselectedItem!)] = true;
      widget.onValueChanged!(value);
    }
  }

  List<Widget> generateToggleButtons() {
    //
    late final ButtonStyle isSelectedStyle = OutlinedButton.styleFrom(
        backgroundColor: Colors.green,
        fixedSize: Size(
            widget.itemSize.width,
            widget.itemsPerRow == null
                ? widget.itemSize.height * 1.2
                : widget.itemSize.height));

    late final ButtonStyle isNotSelectedStyle = OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent, fixedSize: widget.itemSize);

    List<Widget> currentRow = [];
    List<Widget> allRows = [];

    for (String key in widget.valueLabelPairs.keys) {
      int i = widget.valueLabelPairs.keys.toList().indexOf(key);

      // Create new row if current row is filled
      if (widget.itemsPerRow != null) {
        if (i % widget.itemsPerRow! == 0) {
          allRows.add(Row(
            children: [...currentRow],
          ));
          currentRow.clear();
          if (i != widget.valueLabelPairs.length - 1) {
            allRows.add(const SizedBox(
              height: 10,
            ));
          }
        }
      }

      // Adds button to current row
      currentRow.add(OutlinedButton(
        onPressed: () {
          value = widget.valueLabelPairs[key];
          setState(() {
            isSelected = ValueNotifier<List<bool>>(
                List.filled(widget.valueLabelPairs.length, false));
            isSelected.value[i] = true;
          });
          if (widget.onValueChanged != null) {
            widget.onValueChanged!(value);
          }
        },
        child: Text(
          key,
          style: TextStyle(
              color: isSelected.value[i] ? Colors.white : Colors.black,
              fontWeight:
                  isSelected.value[i] ? FontWeight.bold : FontWeight.normal,
              fontSize: widget.fontSize ?? widget.itemSize.height * 0.35),
        ),
        style: isSelected.value[i] ? isSelectedStyle : isNotSelectedStyle,
      ));

      if (i != widget.valueLabelPairs.length - 1) {
        currentRow.add(const SizedBox(width: 10));
      }
    }

    // Return buttons packed in single or multiple rows
    if (allRows.isEmpty) {
      return [
        Row(children: [...currentRow])
      ];
    } else {
      allRows.add(Row(
        children: [...currentRow],
      ));
      return allRows;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<bool>>(
        valueListenable: isSelected,
        builder: (context, value, child) => Column(
              children: [...generateToggleButtons()],
            ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Datatable
const TextStyle dataColumnTextStyle =
    TextStyle(fontSize: 19, fontWeight: FontWeight.bold);
const TextStyle dataCellTextStyle = TextStyle(fontSize: 16);
const TextStyle dataCellBoldTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

// Button
const TextStyle buttonTextStyle = TextStyle(fontSize: 16);

const TextStyle feedbackTextStyle = TextStyle(fontSize: 18);
const TextStyle pageHeadlineTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
const TextStyle pageInfoTextStyle = TextStyle(fontSize: 16);

// Table
const TextStyle tableRowDescriptionTextStyle =
    TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
const TextStyle tableRowTextStyle = TextStyle(fontSize: 17);

const EdgeInsets tableCellPadding = EdgeInsets.all(8);

TextStyle dropDownTextStyle = const TextStyle(fontSize: 16);
const double dropdownArrowSize = 28;

InputDecoration customInputDecoration(String labelText, IconData icon,
    {bool passwordField = false,
    bool isVisible = false,
    void Function()? onPressed}) {
  return InputDecoration(
      labelText: labelText,
      alignLabelWithHint: true,
      border: const OutlineInputBorder(),
      prefixIcon: Icon(icon),
      suffixIcon: passwordField
          ? IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
              ),
              color: isVisible ? Colors.green : Colors.grey,
              onPressed: onPressed)
          : null);
}

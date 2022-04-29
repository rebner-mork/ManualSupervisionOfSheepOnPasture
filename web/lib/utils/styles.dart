import 'package:flutter/material.dart';
import 'package:web/utils/other.dart';

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

InputDecoration customInputDecoration(
    {required String labelText,
    required IconData icon,
    bool passwordField = false,
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

// Registration details
const TextStyle dialogHeadlineTextStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

const double iconSize = 35;

const double verticalRowSpace = 5;
const double verticalTypeSpace = 20;
const double horizontalRowSpace = 15;

const double registrationNoteWidthNarrow = 250;
const double registrationNoteWidthWide = 350;

const TextStyle registrationDetailsNumberTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
const TextStyle registrationDetailsDescriptionTextStyle =
    TextStyle(fontSize: 22);
const TextStyle registrationNoteTextStyle = TextStyle(fontSize: 18);

final double doubleDigitsWidth =
    textSize(text: '99', style: registrationDetailsNumberTextStyle).width + 5;
final double tripleDigitsWidth =
    textSize(text: '999', style: registrationDetailsNumberTextStyle).width + 5;

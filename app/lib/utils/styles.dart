import 'package:app/utils/other.dart';
import 'package:flutter/material.dart';

// Appbar
const TextStyle appBarTextStyle = TextStyle(fontSize: 22);

// User input fields
TextStyle fieldNameTextStyle =
    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
TextStyle dropDownTextStyle = const TextStyle(fontSize: 24);
const double dropdownArrowSize = 40;
const double textFormFieldHeight = 55 + 30;

// Button
TextStyle buttonTextStyle = const TextStyle(fontSize: 18);
Color buttonDisabledColor = Colors.grey;
Color buttonEnabledColor = Colors.green;
double buttonHeight = 40;
double mainButtonHeight = 50;

// Feedback
TextStyle feedbackTextStyle = const TextStyle(fontSize: 16);
TextStyle feedbackErrorTextStyle =
    const TextStyle(fontSize: 16, color: Colors.red);

TextStyle settingsHeadlineTextStyle =
    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
TextStyle settingsHeadlineTwoTextStyle = const TextStyle(fontSize: 20);
TextStyle settingsTextStyle = const TextStyle(fontSize: 18);

// Dialog
TextStyle okDialogButtonTextStyle = const TextStyle(
    fontWeight: FontWeight.w600, fontSize: 18, color: Colors.green);
TextStyle cancelDialogButtonTextStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 18,
);

TextStyle drawerHeadlineTextStyle =
    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

// Registration pages
const TextStyle registrationFieldHeadlineTextStyle = TextStyle(fontSize: 26);

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
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20),
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

const TextStyle registrationDetailsNumberTextStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
const TextStyle registrationDetailsDescriptionTextStyle =
    TextStyle(fontSize: 22);
const TextStyle registrationNoteTextStyle = TextStyle(fontSize: 18);

const double registrationNoteWidthWide = 350;

final double doubleDigitsWidth =
    textSize(text: '99', style: registrationDetailsNumberTextStyle).width + 5;
final double tripleDigitsWidth =
    textSize(text: '999', style: registrationDetailsNumberTextStyle).width + 5;

const EdgeInsets tableCellPadding = EdgeInsets.all(8);

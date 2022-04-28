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
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  size: 20),
              color: isVisible ? Colors.green : Colors.grey,
              onPressed: onPressed)
          : null);
}

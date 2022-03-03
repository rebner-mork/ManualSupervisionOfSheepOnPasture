import 'package:flutter/material.dart';

// User input fields
TextStyle fieldNameTextStyle =
    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold);
TextStyle dropDownTextStyle = const TextStyle(fontSize: 21);

// Button
TextStyle buttonTextStyle = const TextStyle(fontSize: 18);
Color buttonDisabledColor = Colors.grey;
Color buttonEnabledColor = Colors.green;
double buttonHeight = 40;
double mainButtonHeight = 50;
TextStyle circularMapButtonTextStyle =
    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

BoxDecoration circularMapButtonDecoration = BoxDecoration(
    color: Colors.green,
    border: Border.all(color: Colors.transparent, width: 0),
    borderRadius: const BorderRadius.all(Radius.circular(18)),
    boxShadow: const [BoxShadow(blurRadius: 7, offset: Offset(0, 3))]);

BoxDecoration circularMapButtonDecorationPressed = BoxDecoration(
    color: Colors.green.shade700,
    borderRadius: const BorderRadius.all(Radius.circular(18)),
    boxShadow: const [BoxShadow(blurRadius: 7, offset: Offset(0, 3))]);

// Feedback
TextStyle feedbackTextStyle = const TextStyle(fontSize: 16);

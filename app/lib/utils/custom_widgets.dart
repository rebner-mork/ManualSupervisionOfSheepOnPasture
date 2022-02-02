import 'package:flutter/material.dart';

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

SizedBox inputFieldSpacer() {
  return const SizedBox(height: 18);
}

Row customInputRow(String text, TextEditingController controller,
    IconData iconData, Color color) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Flexible(
        flex: 5,
        child: Icon(
          iconData,
          color: color,
          size: 28,
        )),
    const Spacer(),
    Flexible(
        flex: 10,
        child: Container(
            constraints: const BoxConstraints(minWidth: 100),
            child: Text(
              text,
              style: const TextStyle(fontSize: 19),
            ))),
    const Spacer(),
    Flexible(
        flex: 20,
        child: Container(
            constraints: const BoxConstraints(maxWidth: 70),
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.none,
              controller: controller,
              decoration: const InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              ),
            )))
  ]);
}

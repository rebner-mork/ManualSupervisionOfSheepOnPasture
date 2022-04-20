import 'dart:ffi';

import 'package:app/utils/field_validation.dart';
import 'package:flutter/material.dart';

class NoteFormField extends StatelessWidget {
  const NoteFormField(
      {required this.textController,
      this.rightMargin = 0,
      this.maxLines = 3,
      this.validateIsNotEmpty = false,
      Key? key})
      : super(key: key);

  final TextEditingController textController;
  final double rightMargin;
  final int maxLines;
  final bool validateIsNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: rightMargin),
        child: TextFormField(
            validator: (input) =>
                validateIsNotEmpty ? validateNotEmpty(input!) : null,
            textCapitalization: TextCapitalization.sentences,
            maxLines: maxLines,
            controller: textController,
            decoration: const InputDecoration(border: OutlineInputBorder())));
  }
}

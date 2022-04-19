import 'package:flutter/material.dart';

class NoteFormField extends StatelessWidget {
  const NoteFormField(
      {required this.textController, this.rightMargin = 0, Key? key})
      : super(key: key);

  final TextEditingController textController;
  final double rightMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: rightMargin),
        child: TextFormField(
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            controller: textController,
            decoration: const InputDecoration(border: OutlineInputBorder())));
  }
}

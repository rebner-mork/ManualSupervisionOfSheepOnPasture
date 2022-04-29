import 'package:flutter/material.dart';

class TimestampWidget extends StatelessWidget {
  const TimestampWidget({required this.date, Key? key}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
        date.hour.toString().padLeft(2, '0') +
            ':' +
            date.minute.toString().padLeft(2, '0'),
        style: const TextStyle(fontSize: 18),
        textAlign: TextAlign.center);
  }
}

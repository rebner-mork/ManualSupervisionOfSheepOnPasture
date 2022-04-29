import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimestampWidget extends StatelessWidget {
  TimestampWidget({required this.timestamp, Key? key}) : super(key: key) {
    date = timestamp.toDate();
  }

  final Timestamp timestamp;
  late final DateTime date;

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

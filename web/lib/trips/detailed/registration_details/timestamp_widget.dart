import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';

class TimestampWidget extends StatelessWidget {
  TimestampWidget({required this.timestamp, Key? key}) : super(key: key) {
    date = timestamp.toDate();
  }

  final Timestamp timestamp;
  late final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
        timestamp.toDate().hour.toString().padLeft(2, '0') +
            ':' +
            timestamp.toDate().minute.toString().padLeft(2, '0'),
        style: registrationDetailsTimestampTextStyle,
        textAlign: TextAlign.center);
  }
}

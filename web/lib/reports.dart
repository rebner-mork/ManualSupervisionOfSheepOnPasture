import 'package:flutter/material.dart';
import 'package:web/utils/styles.dart';

class ReportSelector extends StatefulWidget {
  const ReportSelector({Key? key}) : super(key: key);

  @override
  State<ReportSelector> createState() => _ReportSelectorState();
}

class _ReportSelectorState extends State<ReportSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Text('Litt info', style: pageInfoTextStyle)],
    );
  }
}

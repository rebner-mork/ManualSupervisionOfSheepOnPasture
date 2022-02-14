import 'package:flutter/material.dart';

class MyTies extends StatefulWidget {
  const MyTies({Key? key}) : super(key: key);

  @override
  State<MyTies> createState() => _MyTiesState();

  static const String route = 'my-ties';
}

class _MyTiesState extends State<MyTies> {
  _MyTiesState();

  bool _loadingData = true; // TODO: false

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // TODO: les inn fra db
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}

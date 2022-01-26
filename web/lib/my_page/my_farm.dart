import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';

class MyFarm extends StatefulWidget {
  const MyFarm(Key? key) : super(key: key);

  @override
  State<MyFarm> createState() => _LoginState();
}

class _LoginState extends State<MyFarm> {
  _LoginState();

  final _formKey = GlobalKey<FormState>();
  late String _farmName, _farmAddress; // TODO: les inn fra db først

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Expanded(
            child: Column(children: [
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 9,
              child: Container(
                  constraints: const BoxConstraints(minWidth: 95),
                  child:
                      const Text('Gårdsnavn', style: TextStyle(fontSize: 16)))),
          const Spacer(),
          Flexible(
              flex: 8,
              child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                      key: const Key('inputFarmName'),
                      validator: (input) =>
                          null, // TODO validateFarmName(input),
                      onSaved: (input) => _farmName = input.toString(),
                      //onChanged,
                      onFieldSubmitted: (value) => null, // TODO
                      decoration: customInputDecoration('Navn', Icons.badge)))),
        ],
      ),
      customFieldSpacing(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              flex: 9,
              child: Container(
                  constraints: const BoxConstraints(minWidth: 95),
                  child: const Text('Gårdsadresse',
                      style: TextStyle(fontSize: 16)))),
          const Spacer(),
          Flexible(
              flex: 8,
              child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                      key: const Key('inputFarmAddress'),
                      validator: (input) =>
                          null, // TODO validateFarmName(input),
                      onSaved: (input) => _farmName = input.toString(),
                      //onChanged,
                      onFieldSubmitted: (value) => null, // TODO
                      decoration:
                          customInputDecoration('Adresse', Icons.badge)))),
        ],
      ),
      const SizedBox(height: 25),
      Center(
          child: ElevatedButton(
              onPressed: () {}, child: const Text("Lagre"))) // TODO
    ])));
  }
}

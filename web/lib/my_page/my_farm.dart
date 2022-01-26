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
        child: FractionallySizedBox(
            widthFactor: 0.6,
            child: Column(children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Flexible(
                      flex: 4,
                      child: Text('Gårdsnavn', style: TextStyle(fontSize: 16))),
                  const Spacer(),
                  Flexible(
                      flex: 10,
                      child: TextFormField(
                          key: const Key('inputFarmName'),
                          validator: (input) =>
                              null, // TODO validateFarmName(input),
                          onSaved: (input) => _farmName = input.toString(),
                          //onChanged,
                          onFieldSubmitted: (value) => null, // TODO
                          decoration:
                              customInputDecoration('Gårdsnavn', Icons.badge))),
                ],
              ),
              customFieldSpacing()
            ])));
  }
}

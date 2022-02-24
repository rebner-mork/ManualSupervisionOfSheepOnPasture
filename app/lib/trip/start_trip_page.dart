import 'package:app/utils/styles.dart';
import 'package:flutter/material.dart';

class StartTripPage extends StatefulWidget {
  const StartTripPage({Key? key}) : super(key: key);

  static const String route = 'start-trip';

  @override
  State<StartTripPage> createState() => _StartTripPageState();
}

class _StartTripPageState extends State<StartTripPage> {
  _StartTripPageState();

  final List<String> _farmNames = ['', 'Gård 1', 'Gård 2', 'Gård 3'];
  late String _selectedFarm;

  String _feedbackText = '';

  @override
  void initState() {
    super.initState();
    _selectedFarm = _farmNames[0];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Start oppsynstur'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Gård',
                      style: fieldNameTextStyle,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                        value: _selectedFarm,
                        items: _farmNames
                            .map((String farmName) => DropdownMenuItem<String>(
                                value: farmName,
                                child: Text(
                                  farmName,
                                  style: dropDownTextStyle,
                                )))
                            .toList(),
                        onChanged: (String? newString) {
                          setState(() {
                            _selectedFarm = newString!;
                            _feedbackText = '';
                          });
                        })
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedFarm == '') {
                        _feedbackText = 'Gård må velges før kart';
                      }
                    });
                  },
                  child: Text(
                    'Velg kart',
                    style: buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size.fromHeight(buttonHeight)),
                      backgroundColor: MaterialStateProperty.all(
                          _selectedFarm == '' ? Colors.grey : Colors.green)),
                ),
                const SizedBox(height: 15),
                Text(
                  _feedbackText,
                  style: feedbackTextStyle,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Start oppsynstur',
                    style: buttonTextStyle,
                  ),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size.fromHeight(mainButtonHeight)),
                      backgroundColor: MaterialStateProperty.all(
                          _selectedFarm == '' ? Colors.grey : Colors.green)),
                )
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:web/my_page/my_farm.dart';

class MyPage extends StatefulWidget {
  const MyPage(Key? key) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  _MyPageState();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(children: <Widget>[
      NavigationRail(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        labelType: NavigationRailLabelType.all, //label
        destinations: const <NavigationRailDestination>[
          NavigationRailDestination(
              icon: Icon(Icons.gite_outlined),
              label: Text(
                'Gård',
                style: NatigationTextStyle,
              ),
              selectedIcon: Icon(Icons.gite)),
          NavigationRailDestination(
              icon: Icon(Icons.hearing_outlined), //Icons.tag (#)
              label: Text(
                'Øremerker',
                style: NatigationTextStyle,
              ),
              selectedIcon: Icon(Icons.hearing)),
          NavigationRailDestination(
              icon: Icon(Icons.filter_alt_outlined),
              label: Text('Slips', style: NatigationTextStyle),
              selectedIcon: Icon(Icons.filter_alt)),
          NavigationRailDestination(
              icon: Icon(Icons.groups_outlined),
              label: Text('Oppsynspersonell', style: NatigationTextStyle),
              selectedIcon: Icon(Icons.groups))
        ],
      ),
      const VerticalDivider(thickness: 1, width: 1),
      if (_selectedIndex == 0) Expanded(child: MyFarm(null))
    ]));
  }
}

const TextStyle NatigationTextStyle = TextStyle(fontWeight: FontWeight.bold);

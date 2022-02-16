import 'package:flutter/material.dart';
import 'package:web/my_page/define_ties.dart';
import 'package:web/my_page/my_farm.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

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
                style: natigationTextStyle,
              ),
              selectedIcon: Icon(Icons.gite)),
          NavigationRailDestination(
              icon: Icon(Icons.local_offer_outlined), //Icons.tag (#)
              label: Text(
                'Øremerker',
                style: natigationTextStyle,
              ),
              selectedIcon: Icon(Icons.local_offer_outlined)),
          NavigationRailDestination(
              icon: Icon(FontAwesome5.black_tie),
              label: Text('Slips', style: natigationTextStyle),
              selectedIcon: Icon(FontAwesome5.black_tie)),
          NavigationRailDestination(
              icon: Icon(Icons.groups_outlined),
              label: Text('Oppsynspersonell', style: natigationTextStyle),
              selectedIcon: Icon(Icons.groups))
        ],
      ),
      const VerticalDivider(thickness: 1, width: 1),
      if (_selectedIndex == 0) const Expanded(child: MyFarm()),
      if (_selectedIndex == 2) const Expanded(child: MyTies())
    ]));
  }
}

const TextStyle natigationTextStyle = TextStyle(fontWeight: FontWeight.bold);

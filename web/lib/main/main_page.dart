import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage(Key? key) : super(key: key);

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  _MainState();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
          length: 3,
          initialIndex: 2,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.grey[800],
              bottom: const TabBar(
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                  //indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                        child: Text(
                      'Årsrapporter',
                      style: TextStyle(fontSize: 16),
                    )),
                    Tab(
                        child: Text('Oppsynsturer',
                            style: TextStyle(fontSize: 16))),
                    Tab(
                        child:
                            Text('Min side', style: TextStyle(fontSize: 16))),
                  ]),
            ),
          )),
    );
  }
}

/* Tab divider (not quite correcty placed)
Container(
                        padding: EdgeInsets.all(0),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                    style: BorderStyle.solid))),
                        child: const Tab(
                            child: Text(
                          'Årsrapporter',
                          style: TextStyle(fontSize: 16),
                        ))),
*/
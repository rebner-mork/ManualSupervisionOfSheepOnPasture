import 'package:flutter/material.dart';
import 'package:web/my_page/my_page.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({Key? key}) : super(key: key);

  @override
  State<MainTabs> createState() => _MainState();

  static const String route = 'main-page';
}

class _MainState extends State<MainTabs> {
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
              bottom: TabBar(
                  unselectedLabelColor: Colors.grey[400],
                  indicator: const UnderlineTabIndicator(
                    borderSide:
                        BorderSide(width: 3, color: Colors.green), //Colors.red
                  ),
                  //indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(
                        child: Text(
                      'Årsrapporter',
                      style: TextStyle(fontSize: 18),
                    )),
                    Tab(
                        child: Text('Oppsynsturer',
                            style: TextStyle(fontSize: 18))),
                    Tab(
                        child:
                            Text('Min side', style: TextStyle(fontSize: 18))),
                  ]),
            ),
            body: const TabBarView(children: [Text('1'), Text('2'), MyPage()]),
          )),
    );
  }
}

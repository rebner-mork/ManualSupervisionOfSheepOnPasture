import 'package:flutter/material.dart';
import 'package:web/my_page/my_page.dart';
import 'package:web/utils/styles.dart';

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
            appBar: PreferredSize(
                child: Container(
                    color: Colors.grey[800],
                    child: Padding(
                        padding: const EdgeInsets.only(left: 128),
                        child: AppBar(
                          toolbarHeight: 0,
                          backgroundColor: Colors.grey[800],
                          bottom: TabBar(
                              unselectedLabelColor: Colors.grey[400],
                              indicator: const UnderlineTabIndicator(
                                borderSide: BorderSide(
                                    width: 3, color: Colors.green), //Colors.red
                              ),
                              //indicatorSize: TabBarIndicatorSize.label,
                              tabs: [
                                Tab(
                                    child: Text(
                                  'Årsrapporter',
                                  style: mainTabsTextStyle,
                                )),
                                Tab(
                                    child: Text('Oppsynsturer',
                                        style: mainTabsTextStyle)),
                                Tab(
                                    child: Text('Min side',
                                        style: mainTabsTextStyle)),
                              ]),
                        ))),
                preferredSize: const Size.fromHeight(48)),
            body: const TabBarView(children: [Text('1'), Text('2'), MyPage()]),
          )),
    );
  }
}

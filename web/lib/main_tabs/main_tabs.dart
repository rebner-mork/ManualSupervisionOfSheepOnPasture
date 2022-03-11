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
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                  color: Colors.grey.shade800,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 128),
                      child: AppBar(
                        toolbarHeight: 0,
                        backgroundColor: Colors.grey.shade800,
                        bottom: TabBar(
                            labelStyle: const TextStyle(
                              fontSize: 24,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey.shade200, // 300
                            indicator: const UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 5, color: Colors.green),
                            ),
                            //indicatorSize: TabBarIndicatorSize.label,
                            tabs: const [
                              Tab(child: Text('Årsrapporter')),
                              Tab(child: Text('Oppsynsturer')),
                              Tab(child: Text('Min side')),
                            ]),
                      ))),
            ),
            body: const TabBarView(children: [Text('1'), Text('2'), MyPage()]),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:web/my_page/my_page.dart';
import 'package:web/reports_page.dart';
import 'package:web/trips/trips.dart';

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
              preferredSize: const Size.fromHeight(50),
              child: Container(
                  color: Colors.grey.shade800,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 128),
                      child: AppBar(
                        toolbarHeight: 0,
                        backgroundColor: Colors.grey.shade800,
                        bottom: TabBar(
                            overlayColor: MaterialStateProperty.all(
                                Colors.green.shade700),
                            labelStyle: const TextStyle(
                              fontSize: 24,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey.shade200,
                            indicator: const UnderlineTabIndicator(
                              borderSide:
                                  BorderSide(width: 7, color: Colors.green),
                            ),
                            //indicatorSize: TabBarIndicatorSize.label,
                            tabs: const [
                              Tab(child: Text('Årsrapporter')),
                              Tab(child: Text('Oppsynsturer')),
                              Tab(child: Text('Min side')),
                            ]),
                      ))),
            ),
            body: TabBarView(children: [
              Row(mainAxisSize: MainAxisSize.max, children: [
                Container(
                    constraints:
                        const BoxConstraints(minWidth: 128, maxWidth: 128),
                    color: Colors.grey.shade800),
                const Expanded(child: ReportsPage())
              ]),
              const TripsPage(),
              const MyPage()
            ]),
          )),
    );
  }
}

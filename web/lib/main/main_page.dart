import 'package:flutter/material.dart';
import 'package:web/my_page/my_page.dart';

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
                      style: TabTextStyle,
                    )),
                    Tab(child: Text('Oppsynsturer', style: TabTextStyle)),
                    Tab(child: Text('Min side', style: TabTextStyle)),
                  ]),
            ),
            body: const TabBarView(
                children: [Text('1'), Text('2'), MyPage(null)]),
          )),
    );
  }
}

const TextStyle TabTextStyle = TextStyle(fontSize: 18);

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
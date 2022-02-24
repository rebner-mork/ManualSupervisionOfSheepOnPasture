import 'package:flutter/material.dart';

import 'package:app/utils/map_utils.dart';

class MyMapsPage extends StatefulWidget {
  const MyMapsPage({Key? key}) : super(key: key);

  static final String route = "my-maps";

  @override
  State<MyMapsPage> createState() => _MyMapsPageState();
}

class _MyMapsPageState extends State<MyMapsPage> {
  _MyMapsPageState();

  Widget _getMapListItem(Image thumbnail, String mapName) {
    return Container(
      child: Row(
        children: <Widget>[/*Image(image: )*/ Text(mapName)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Velg et kart")),
        body: Container(
            child: Center(
                child: ElevatedButton(
          child: Text(":)"),
          onPressed: () {
            getAllMapsFromFarm("vsW7psVbqNX5bF35m3GR3K0LzVD3");
          },
        ))));
  }
}


/* Denne widgeten tar jo inn en farm-id og da sparer man jo en del jobb*/

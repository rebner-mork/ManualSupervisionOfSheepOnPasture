import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

class CadaverTable extends StatefulWidget {
  const CadaverTable({required this.cadaverData, Key? key}) : super(key: key);

  final List<Map<String, dynamic>> cadaverData;

  @override
  State<CadaverTable> createState() => _CadaverTableState();
}

class _CadaverTableState extends State<CadaverTable> {
  bool _isLoading = true;
  late final List<List> _photoUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    for (Map<String, dynamic> registration in widget.cadaverData) {
      List urls = registration['photos'] as List;

      if (urls.isNotEmpty) {
        final List<String> modifiedUrls = [];
        for (dynamic url in urls) {
          String downloadUrl =
              await FirebaseStorage.instance.ref().child(url).getDownloadURL();
          modifiedUrls.add(downloadUrl);
        }
        _photoUrls.add(modifiedUrls);
      } else {
        _photoUrls.add([]);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(width: 0.5),
      ),
      columnWidths: const {
        0: FixedColumnWidth(150),
        1: FixedColumnWidth(60),
        2: FixedColumnWidth(125)
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        const TableRow(children: [
          Padding(
              padding: tableCellPadding,
              child: Text('Øremerke',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center)),
          Padding(
              padding: tableCellPadding,
              child: Text('Slips',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center)),
          Padding(
              padding: tableCellPadding,
              child: Text('Notat & bilder',
                  style: tableRowDescriptionTextStyle,
                  textAlign: TextAlign.center)),
        ]),
        ...widget.cadaverData.map((Map<String, dynamic> registration) {
          List<String> eartag = (registration['eartag'] as String).split('-');

          return TableRow(
            children: [
              Padding(
                  padding: tableCellPadding,
                  child: Text(
                    '${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
                    style: tableRowTextStyle,
                    textAlign: TextAlign.center,
                  )),
              Padding(
                  padding: tableCellPadding,
                  child: Icon(
                    registration['tieColor'] == '0'
                        ? Icons.disabled_by_default
                        : FontAwesome5.black_tie,
                    size: 24,
                    color: registration['tieColor'] == '0'
                        ? Colors.grey
                        : Color(int.parse(registration['tieColor'], radix: 16)),
                  )),
              Padding(
                  padding: tableCellPadding,
                  child: _isLoading
                      ? const LoadingData(smallCircleOnly: true)
                      : IconButton(
                          icon: const Icon(Icons.description),
                          color: Colors.grey.shade700,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => SimpleDialog(
                                      title: const Text(
                                        'Kadaver',
                                        textAlign: TextAlign.center,
                                      ),
                                      titleTextStyle:
                                          const TextStyle(fontSize: 26),
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          0.0, 1.0, 0.0, 16.0),
                                      children: [
                                        Text(
                                            '${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
                                            style:
                                                const TextStyle(fontSize: 18),
                                            textAlign: TextAlign.center),
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child: Text(
                                                '${registration['note']}',
                                                style: const TextStyle(
                                                    fontSize: 16))),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ...(_photoUrls[widget.cadaverData
                                                      .indexOf(registration)])
                                                  .map((photoUrl) =>
                                                      Row(children: [
                                                        const SizedBox(
                                                            width: 8),
                                                        Image.network(
                                                          photoUrl as String,
                                                          width: 300,
                                                        ),
                                                        const SizedBox(width: 8)
                                                      ]))
                                                  .toList()
                                            ])
                                      ],
                                    ));
                          }))
            ],
          );
        })
      ],
    );
  }
}

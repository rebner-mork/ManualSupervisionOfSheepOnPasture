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
  late final List<List> photoUrls = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    debugPrint("start");
    for (Map<String, dynamic> registration in widget.cadaverData) {
      List urls = registration['photos'] as List;

      if (urls.isNotEmpty) {
        final List<String> modifiedUrls = [];
        for (dynamic url in urls) {
          // TODO: replace url
          String downloadUrl = await FirebaseStorage.instance
              .ref()
              .child(
                  '/users/eNHgl2gWR6OIojWc1bTJNJqZNkp1//cadavers/CAP1840324410685016933.jpg')
              .getDownloadURL();
          modifiedUrls.add(downloadUrl);
        }
        photoUrls.add(modifiedUrls);
      } else {
        photoUrls.add([]);
      }
    }
    debugPrint("slutt");
    debugPrint(photoUrls.toString());

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
                    color:
                        Color(int.parse(registration['tieColor'], radix: 16)),
                  )),
              Padding(
                  padding: tableCellPadding,
                  child: IconButton(
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
                                  titleTextStyle: const TextStyle(fontSize: 26),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      0.0, 1.0, 0.0, 16.0),
                                  children: [
                                    Text(
                                        '${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Text('${registration['note']}',
                                            style:
                                                const TextStyle(fontSize: 16))),
                                    if (_isLoading)
                                      const LoadingData(
                                          text: 'Laster inn bilder...'),
                                    if (!_isLoading)
                                      ...(/*registration['photos'] as List*/ photoUrls[
                                              widget.cadaverData
                                                  .indexOf(registration)])
                                          .map((photoUrl) =>
                                              Image.network(photoUrl as String))
                                          //    'https://storage.googleapis.com/master-backend-93896.appspot.com/users/eNHgl2gWR6OIojWc1bTJNJqZNkp1//cadavers/CAP1840324410685016933.jpg'))
                                          //'https://firebasestorage.googleapis.com/v0/b/master-backend-93896.appspot.com/o/users%2FeNHgl2gWR6OIojWc1bTJNJqZNkp1%2Fcadavers%2FCAP1840324410685016933.jpg?alt=media&token=13008e19-9652-41cb-93cb-c9c6aacc8535'))
                                          .toList(),
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
/*
class CadaverTable extends StatelessWidget {
  const CadaverTable({required this.cadaverData, Key? key}) : super(key: key);

  final List<Map<String, dynamic>> cadaverData;

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
        ...cadaverData.map((Map<String, dynamic> registration) {
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
                    color:
                        Color(int.parse(registration['tieColor'], radix: 16)),
                  )),
              Padding(
                  padding: tableCellPadding,
                  child: IconButton(
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
                                  titleTextStyle: const TextStyle(fontSize: 26),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      0.0, 1.0, 0.0, 16.0),
                                  children: [
                                    Text(
                                        '${eartag[0]}-${eartag[1]}\n${eartag[2]}-${eartag[3]}',
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Text('${registration['note']}',
                                            style:
                                                const TextStyle(fontSize: 16))),
                                    ...(registration['photos'] as List)
                                        .map((photoUrl) => Image.network(
                                            //    'https://storage.googleapis.com/master-backend-93896.appspot.com/users/eNHgl2gWR6OIojWc1bTJNJqZNkp1//cadavers/CAP1840324410685016933.jpg'))
                                            'https://firebasestorage.googleapis.com/v0/b/master-backend-93896.appspot.com/o/users%2FeNHgl2gWR6OIojWc1bTJNJqZNkp1%2Fcadavers%2FCAP1840324410685016933.jpg?alt=media&token=13008e19-9652-41cb-93cb-c9c6aacc8535'))
                                        .toList(),
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
*/

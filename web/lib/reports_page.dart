import 'dart:collection';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:html' as html;

final pw.TextStyle columnHeaderTextStyle =
    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);
final int tripsPerPage = 24;

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isLoading = true;
  late final SplayTreeSet<int> years = SplayTreeSet((a, b) => a.compareTo(b));
  late int _selectedYear;
  late bool _tripsExist;
  html.AnchorElement? anchorElement;
  late List<QueryDocumentSnapshot<Object?>> _allTripDocuments;
  int _pdfTripsTableHeadersAdded = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readTrips();
    });
  }

  void _readTrips() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference tripsCollection =
        FirebaseFirestore.instance.collection('trips');

    QuerySnapshot<Object?> tripsSnapshot =
        await tripsCollection.where('farmId', isEqualTo: uid).get();
    _allTripDocuments = tripsSnapshot.docs;

    if (_allTripDocuments.isNotEmpty) {
      for (QueryDocumentSnapshot tripDoc in _allTripDocuments) {
        years.add((tripDoc['startTime'] as Timestamp).toDate().year);
      }

      setState(() {
        _tripsExist = true;
        _selectedYear = years.last;
        _isLoading = false;
      });
    } else {
      setState(() {
        _tripsExist = false;
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _generateReport() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference farmsCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentSnapshot farmDoc = await farmsCollection.doc(uid).get();

    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot farmOwnerQuerySnapshot = await usersCollection
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    DocumentSnapshot farmOwnerDoc = farmOwnerQuerySnapshot.docs.first;

    Set<String> personnel = {};

// TODO: order by date (and possibly startTime)
    List<QueryDocumentSnapshot<Object?>?> tripsFromYear = [];

    _allTripDocuments
        .asMap()
        .entries
        .map((MapEntry<int, QueryDocumentSnapshot> tripDocMap) {
      if ((tripDocMap.value['startTime'] as Timestamp).toDate().year ==
          _selectedYear) {
        personnel.add(tripDocMap.value[
            'personnelEmail']); // TODO: Change to full name when available

        if (tripDocMap.key != 0 && tripDocMap.key % tripsPerPage == 0) {
          tripsFromYear.add(null);
          _pdfTripsTableHeadersAdded++;
        }
        tripsFromYear.add(tripDocMap.value);
      }
    }).toList();

    final pw.Document pdf = pw.Document();

    var logoImage = pw.MemoryImage(
        (await rootBundle.load('images/app_icon.png')).buffer.asUint8List());

    pdf.addPage(metaPdfPage(logoImage, farmDoc, farmOwnerDoc, personnel,
        tripsFromYear.length - _pdfTripsTableHeadersAdded));

    // Loop registreringer
    List<Map<String, Object>?> tripSummaries = [];
    for (QueryDocumentSnapshot<Object?>? tripDoc in tripsFromYear) {
      if (tripDoc != null) {
        CollectionReference registrationsCollection = FirebaseFirestore.instance
            .collection('trips')
            .doc(tripDoc.id)
            .collection('registrations');
        QuerySnapshot registrationsQuerySnapshot =
            await registrationsCollection.get();

        int totalSheepAmount = 0;
        int totalLambAmount = 0;

        for (DocumentSnapshot<Object?>? registrationDoc
            in registrationsQuerySnapshot.docs) {
          totalSheepAmount += registrationDoc!['sheep'] as int;
          totalLambAmount += registrationDoc['lambs'] as int;
        }
        tripSummaries.add({
          'startTime': tripDoc['startTime'],
          'stopTime': tripDoc['stopTime'],
          'sheep': totalSheepAmount,
          'adults': totalSheepAmount - totalLambAmount,
          'lambs': totalLambAmount
        });
      } else {
        tripSummaries.add(null);
      }
    }

    pdf.addPage(pdfTripsTable(tripSummaries));

    return pdf.save();
  }

  pw.Page metaPdfPage(logoImage, farmDoc, farmOwnerDoc, personnel, tripAmount) {
    return pw.Page(build: (pw.Context context) {
      return pw.Column(children: [
        pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, width: 45),
                  pw.Text('Årsrapport $_selectedYear',
                      style: const pw.TextStyle(fontSize: 30),
                      textAlign: pw.TextAlign.center),
                  pw.SizedBox(width: 45)
                ])),
        pw.Table(
            tableWidth: pw.TableWidth.min,
            border: pw.TableBorder.all(width: 0.5),
            children: [
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Gård', style: columnHeaderTextStyle)),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(farmDoc['name'])),
              ]),
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Adresse', style: columnHeaderTextStyle)),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(farmDoc['address'])),
              ]),
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Gårdseier', style: columnHeaderTextStyle)),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('E-post: ' +
                        farmOwnerDoc['email'] +
                        '\nTlf:       ' +
                        farmOwnerDoc['phone'])), // TODO: fullt navn
              ]),
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Oppsynspersonell',
                        style: columnHeaderTextStyle)),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(personnel
                        .toString()
                        .replaceAll(', ', '\n')
                        .replaceAll('{', '')
                        .replaceAll('}', '')))
              ]),
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Antall oppsynsturer',
                        style: columnHeaderTextStyle)),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('$tripAmount')),
              ]),
            ])
      ]);
    });
  }

  pw.MultiPage pdfTripsTable(List<Map<String, Object>?> tripSummaries) {
    //List<QueryDocumentSnapshot<Object?>?> trips) {
    return pw.MultiPage(
        pageFormat: PdfPageFormat(
            PdfPageFormat.a4.width, PdfPageFormat.a4.height,
            marginAll: 1 * PdfPageFormat.cm),
        build: (pw.Context context) {
          return [
            pw.Table(
                border: pw.TableBorder.symmetric(
                    inside: const pw.BorderSide(width: 0.5),
                    outside: const pw.BorderSide(width: 0.5)),
                columnWidths: const {
                  0: pw.FixedColumnWidth(50),
                  1: pw.FixedColumnWidth(50),
                  2: pw.FixedColumnWidth(35),
                  3: pw.FixedColumnWidth(35),
                  4: pw.FixedColumnWidth(35),
                  5: pw.FixedColumnWidth(35),
                  6: pw.FixedColumnWidth(35),
                  7: pw.FixedColumnWidth(35),
                },
                children: [
                  pdfTripsTableHeaders(),
                  ...tripSummaries
                      .asMap()
                      .entries
                      .map((MapEntry<int, Map<String, Object>?> tripMap) {
                    if (tripMap.value == null) {
                      return pdfTripsTableHeaders();
                    } else {
                      DateTime startTime =
                          (tripMap.value!['startTime']! as Timestamp).toDate();
                      DateTime stopTime =
                          (tripMap.value!['stopTime']! as Timestamp).toDate();

                      return pw.TableRow(children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                '${startTime.day.toString().padLeft(2, '0')}/${startTime.month.toString().padLeft(2, '0')}/${startTime.year}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} - ${stopTime.hour}:${stopTime.minute.toString().padLeft(2, '0')}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${tripMap.value!['sheep']}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${tripMap.value!['adults']}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${tripMap.value!['lambs']}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child:
                                pw.Text('x', textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child:
                                pw.Text('x', textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child:
                                pw.Text('x', textAlign: pw.TextAlign.center)),
                      ]);
                    }
                  })
                ])
          ];
        });
  }

// TODO: subclass?
  pw.TableRow pdfTripsTableHeaders() {
    return pw.TableRow(children: [
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Dato',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Tid',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Sauer\ntotalt',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Voksne',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Lam',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Skadde',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Døde',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
      pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text('Rovdyr',
              style: columnHeaderTextStyle, textAlign: pw.TextAlign.center)),
    ]);
  }

  Future<void> _downloadReport() async {
    Uint8List pdfInBytes = await _generateReport();

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchorElement = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'report.pdf';
    html.document.body?.children.add(anchorElement!);
    anchorElement!.click();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingData()
        : _tripsExist
            ? Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('Her kan du generere og laste ned årsrapporter',
                      style: pageInfoTextStyle),
                  DropdownButton<int>(
                      value: _selectedYear,
                      items: years
                          .map<DropdownMenuItem<int>>(
                              (int year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(
                                    year.toString(),
                                    style: const TextStyle(fontSize: 26),
                                  )))
                          .toList(),
                      onChanged: (int? newYear) {
                        setState(() {
                          _selectedYear = newYear!;
                        });
                      }),
                  ElevatedButton(
                      onPressed: _downloadReport,
                      child: const Text(
                        "Last ned årsrapport",
                        style: TextStyle(fontSize: 22),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(230, 60),
                      ))
                ],
              )
            : const Center(
                child: Text('Ingen turer har blitt gått',
                    style: feedbackTextStyle));
  }
}

class FirstPdfPage extends pw.Page {
  FirstPdfPage({required pw.BuildCallback build, Key? key})
      : super(build: build);
}

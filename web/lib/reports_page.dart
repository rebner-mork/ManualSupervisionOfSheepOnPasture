import 'dart:collection';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:web/utils/custom_widgets.dart';
import 'package:web/utils/styles.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

final pw.TextStyle columnHeaderTextStyle =
    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  bool _isLoading = true;
  bool _isGeneratingReport = false;
  late bool _tripsExist;

  late final List<QueryDocumentSnapshot<Object?>> _allTripDocuments;
  late final SplayTreeSet<int> availableYears =
      SplayTreeSet((a, b) => a.compareTo(b));
  late int _selectedYear;

  html.AnchorElement? anchorElement;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _readAllTrips();
    });
  }

  void _readAllTrips() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot tripsQuerySnapshot = await FirebaseFirestore.instance
        .collection('farms')
        .doc(uid)
        .collection('trips')
        .orderBy('startTime')
        .get();

    _allTripDocuments = tripsQuerySnapshot.docs;

    if (_allTripDocuments.isNotEmpty) {
      for (QueryDocumentSnapshot tripDoc in _allTripDocuments) {
        availableYears.add((tripDoc['startTime'] as Timestamp).toDate().year);
      }

      setState(() {
        _selectedYear = availableYears.last;
        _tripsExist = true;
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
    // Get farm-document
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference farmsCollection =
        FirebaseFirestore.instance.collection('farms');
    DocumentSnapshot farmDoc = await farmsCollection.doc(uid).get();

    // Get user-document of farm-owner
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    QuerySnapshot farmOwnerQuerySnapshot = await usersCollection
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    // Extract data from trips from selected year
    int tripAmountFromYear = 0;
    Set<String> personnelFromYearEmails = {};
    SplayTreeSet<QueryDocumentSnapshot> tripsFromYear = SplayTreeSet(((a, b) =>
        (a['startTime'] as Timestamp)
            .toDate()
            .compareTo((b['startTime'] as Timestamp).toDate())));

    _allTripDocuments
        .asMap()
        .entries
        .map((MapEntry<int, QueryDocumentSnapshot> tripDocMap) {
      if ((tripDocMap.value['startTime'] as Timestamp).toDate().year ==
          _selectedYear) {
        tripAmountFromYear++;
        personnelFromYearEmails.add(tripDocMap.value['personnelEmail']);
        tripsFromYear.add(tripDocMap.value);
      }
    }).toList();

    // Get names of personnel
    List<String> personnelFromYearNames = [];
    QuerySnapshot userDocSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .where('email', whereIn: personnelFromYearEmails.toList())
        .get();
    for (DocumentSnapshot userDoc in userDocSnapshots.docs) {
      personnelFromYearNames.add(userDoc['name'] as String);
    }

    // Summarize each trip
    List<Map<String, Object>?> tripSummaries =
        await _summarizeTrips(tripsFromYear);

    // Create PDF-document
    final pw.Document pdf = pw.Document();
    pdf.addPage(metaPdfPage(farmDoc, farmOwnerQuerySnapshot.docs.first,
        personnelFromYearNames, tripAmountFromYear));
    pdf.addPage(pdfTripsTablePages(tripSummaries));

    return pdf.save();
  }

  Future<List<Map<String, Object>?>> _summarizeTrips(
      SplayTreeSet<QueryDocumentSnapshot<Object?>?> tripDocuments) async {
    List<Map<String, Object>?> tripSummaries = [];

    for (int i = 0; i < tripDocuments.length; i++) {
      // If this trip will cause a page-wrap, add null to make pdfTripsTablePages-function add columnHeaderRow
      if (i != 0 && i % 25 == 0) {
        tripSummaries.add(null);
      } else {
        CollectionReference registrationsCollection = FirebaseFirestore.instance
            .collection('trips')
            .doc(tripDocuments.elementAt(i)!.id)
            .collection('registrations');
        QuerySnapshot registrationsQuerySnapshot =
            await registrationsCollection.get();

        int totalSheepAmount = 0;
        int totalLambAmount = 0;
        int totalInjuredSheepAmount = 0;

        for (DocumentSnapshot<Object?> registrationDoc
            in registrationsQuerySnapshot.docs) {
          switch (registrationDoc['type']) {
            case 'injuredSheep':
              totalInjuredSheepAmount++;
              totalSheepAmount++;
              break;
            default:
              totalSheepAmount += registrationDoc['sheep'] as int;
              totalLambAmount += registrationDoc['lambs'] as int;
              break;
          }
        }
        tripSummaries.add({
          'startTime': tripDocuments.elementAt(i)!['startTime'],
          'stopTime': tripDocuments.elementAt(i)!['stopTime'],
          'sheep': totalSheepAmount,
          'adults': totalSheepAmount - totalLambAmount,
          'lambs': totalLambAmount,
          'injuredSheep': totalInjuredSheepAmount
        });
      }
    }
    return tripSummaries;
  }

  pw.Page metaPdfPage(farmDoc, farmOwnerDoc, personnel, tripAmount) {
    return pw.Page(build: (pw.Context context) {
      return pw.Column(children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 20),
          child: pw.Center(
              child: pw.Text('Årsrapport $_selectedYear',
                  style: const pw.TextStyle(fontSize: 30),
                  textAlign: pw.TextAlign.center)),
        ),
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
                    child: pw.Text(farmOwnerDoc['name'] +
                        '\n' +
                        farmOwnerDoc['email'] +
                        '\n' +
                        farmOwnerDoc['phone'] +
                        '\n')),
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
                        .replaceAll('[', '')
                        .replaceAll(']', '')))
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

  pw.MultiPage pdfTripsTablePages(List<Map<String, Object>?> tripSummaries) {
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
                  ...tripSummaries.map((tripMap) {
                    if (tripMap == null) {
                      return pdfTripsTableHeaders();
                    } else {
                      DateTime startTime =
                          (tripMap['startTime']! as Timestamp).toDate();
                      DateTime stopTime =
                          (tripMap['stopTime']! as Timestamp).toDate();

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
                            child: pw.Text('${tripMap['sheep']}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${tripMap['adults']}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${tripMap['lambs']}',
                                textAlign: pw.TextAlign.center)),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${tripMap['injuredSheep']}',
                                textAlign: pw.TextAlign.center)),
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
          child: pw.Text('Sauer',
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
    setState(() {
      _isGeneratingReport = true;
    });
    Uint8List pdfInBytes = await _generateReport();
    setState(() {
      _isGeneratingReport = false;
    });

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchorElement = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'Årsrapport$_selectedYear.pdf';
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
                  const SizedBox(height: 30),
                  const Text('Her kan du generere og laste ned årsrapporter',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Velg år:  ', style: TextStyle(fontSize: 24)),
                    DropdownButton<int>(
                        value: _selectedYear,
                        items: availableYears
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
                        })
                  ]),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: _downloadReport,
                      child: const Text(
                        "Last ned årsrapport",
                        style: TextStyle(fontSize: 22),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(230, 60),
                      )),
                  if (_isGeneratingReport)
                    const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: LoadingData(
                          text: 'Genererer rapport...',
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

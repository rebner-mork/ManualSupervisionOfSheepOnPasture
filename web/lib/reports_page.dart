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

    List<QueryDocumentSnapshot<Object?>?> tripsFromYear =
        []; // TODO: order by date (and possibly startTime)
    _allTripDocuments.map((QueryDocumentSnapshot tripDoc) {
      if ((tripDoc['startTime'] as Timestamp).toDate().year == _selectedYear) {
        personnel.add(tripDoc[
            'personnelEmail']); // TODO: Change to full name when available
        tripsFromYear.add(tripDoc);
      }
    }).toList();

    /*for (DocumentSnapshot tripDoc in _allTripDocuments) {
      if ((tripDoc['startTime'] as Timestamp).toDate().year == _selectedYear) {
        //_tripsFromYear.add()
        //tripAmount++;
        personnel.add(tripDoc[
            'personnelEmail']); // TODO: Change to full name when available
      }
    }*/

    final pw.Document pdf = pw.Document();

    var logoImage = pw.MemoryImage(
        (await rootBundle.load('images/app_icon.png')).buffer.asUint8List());

    pdf.addPage(metaPdfPage(
        logoImage, farmDoc, farmOwnerDoc, personnel, tripsFromYear.length));
    pdf.addPage(pdfTripsTable(tripsFromYear));

    return pdf.save();
  }

  pw.Page metaPdfPage(logoImage, farmDoc, farmOwnerDoc, personnel, tripAmount) {
    return pw.Page(build: (pw.Context context) {
      return pw.Center(
          child: pw.Column(children: [
        pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 20),
            child: pw.Text('Årsrapport $_selectedYear',
                style: const pw.TextStyle(fontSize: 30),
                textAlign: pw.TextAlign.center)),
        pw.Image(logoImage, width: 80),
        pw.Table(
            border: pw.TableBorder.symmetric(
                inside: const pw.BorderSide(width: 0.5)),
            columnWidths: const {
              0: pw.FixedColumnWidth(35),
              1: pw.FixedColumnWidth(100)
            },
            children: [
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Gård')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(farmDoc['name'])),
              ]),
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Adresse')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text(farmDoc['address'])),
              ]),
              pw.TableRow(children: [
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('Gårdseier')),
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
                    child: pw.Text('Oppsynspersonell')),
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
                    child: pw.Text('Antall oppsynsturer')),
                pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text('$tripAmount')),
              ]),
            ])
      ]));
    });
  }

  pw.Page pdfTripsTable(List<QueryDocumentSnapshot<Object?>?> trips) {
    final pw.TextStyle columnHeaderTextStyle =
        pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);

    return pw.Page(
        pageFormat: PdfPageFormat(
            PdfPageFormat.a4.width, PdfPageFormat.a4.height,
            marginAll: 1 * PdfPageFormat.cm // 2 default
            ),
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Table(
                  border: pw.TableBorder.symmetric(
                      inside: const pw.BorderSide(width: 0.5),
                      outside: const pw.BorderSide(width: 0.5)),
                  columnWidths: const {
                0: pw.FixedColumnWidth(46),
                1: pw.FixedColumnWidth(55),
                2: pw.FixedColumnWidth(35),
                3: pw.FixedColumnWidth(40),
                4: pw.FixedColumnWidth(35),
                5: pw.FixedColumnWidth(38),
                6: pw.FixedColumnWidth(35),
                7: pw.FixedColumnWidth(40),
              },
                  children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Dato',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Tidsperiode',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Sauer\ntotalt',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Voksne',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Lam',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Skadde',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Døde',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('Rovdyr',
                          style: columnHeaderTextStyle,
                          textAlign: pw.TextAlign.center)),
                ]),
                ...trips.map((QueryDocumentSnapshot<Object?>? tripDoc) {
                  DateTime startTime =
                      (tripDoc!['startTime']! as Timestamp).toDate();
                  DateTime stopTime =
                      (tripDoc['stopTime']! as Timestamp).toDate();

                  return pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            '${startTime.day.toString().padLeft(2, '0')}/${startTime.month.toString().padLeft(2, '0')}/${startTime.year}',
                            textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                            // Klokkeslett rett fra db er feil? Blir riktig etter å ha endret dem i Firestore(?)
                            '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}-${stopTime.hour}:${stopTime.minute.toString().padLeft(2, '0')}',
                            textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('0', textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('1', textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('2', textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('3', textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('4', textAlign: pw.TextAlign.center)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('5', textAlign: pw.TextAlign.center)),
                  ]);
                }).toList()
              ]));
        });
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
                        "Generer rapport",
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(180, 50),
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

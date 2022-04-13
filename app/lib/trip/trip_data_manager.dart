import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

import '../utils/constants.dart';

class TripDataManager {
  TripDataManager.start(
      {required this.farmId,
      required this.personnelEmail,
      required this.mapName}) {
    _startTime = DateTime.now();
  }

  TripDataManager.fromJson(String json) {
    try {
      Map<String, dynamic> data = jsonDecode(json);

      farmId = data['farmId'].toString();
      personnelEmail = data['personnelEmail'].toString();
      mapName = data['mapName'].toString();

      _startTime = DateTime.parse(data['startTime']);
      _stopTime = DateTime.parse(data['stopTime']);

      registrations.addAll(data['registrations']);
      for (int i = 0; i < registrations.length; i++) {
        registrations[i]['timestamp'] =
            DateTime.parse(registrations[i]['timestamp']);
      }

      for (int i = 0; i < data['track'].length; i++) {
        track.add(LatLng(
            data['track'][i]['latitude'], data['track'][i]['longitude']));
      }
    } catch (e) {
      developer.log(e.toString());
    }
  }

  late String farmId;
  late String personnelEmail;
  late String mapName;
  late final DateTime _startTime;
  DateTime? _stopTime;
  List<dynamic> registrations = [];
  List<LatLng> track = [];

  void post() {
    _stopTime ??= DateTime.now();

    // --- TRIPS ---

    CollectionReference tripCollection = FirebaseFirestore.instance
        .collection('farms')
        .doc(farmId)
        .collection('trips');
    DocumentReference tripDocument = tripCollection.doc();

    List<Map<String, double>> preparedTrack = _getPreparedTrack();

    tripDocument.set({
      'personnelEmail': personnelEmail,
      'startTime': _startTime,
      'stopTime': _stopTime,
      'track': preparedTrack,
      'mapName': mapName,
    });

    // --- REGISTRATIONS ---

    CollectionReference registrationSubCollection =
        tripDocument.collection('registrations');

    for (var registration in registrations) {
      DocumentReference registrationDocument = registrationSubCollection.doc();
      registrationDocument.set(registration);
    }
  }

  List<Map<String, double>> _getPreparedTrack() {
    List<Map<String, double>> preparedTrack = [];

    for (LatLng coordinate in track) {
      preparedTrack.add(
          {'latitude': coordinate.latitude, 'longitude': coordinate.longitude});
    }
    return preparedTrack;
  }

  void archive() {
    _stopTime ??= DateTime.now();

    var preparedRegistrations = [];
    preparedRegistrations.addAll(registrations);

    for (var entry in preparedRegistrations) {
      entry['timestamp'] = entry['timestamp'].toString();
    }

    Map<String, Object?> data = {
      'farmId': farmId,
      'personnelEmail': personnelEmail,
      'mapName': mapName,
      'startTime': _startTime.toString(),
      'stopTime': _stopTime.toString(),
      'registrations': preparedRegistrations,
      'track': _getPreparedTrack(),
    };

    String jsonData = jsonEncode(data);

    String path = applicationDocumentDirectoryPath + "/trips";

    Directory(path).create(recursive: true);

    String fileName = path +
        "/" +
        mapName +
        "_" +
        _startTime.toString().replaceAll(" ", "_").split(".")[0] +
        ".json";

    File(fileName).writeAsStringSync(jsonData);
  }

  @override
  String toString() {
    Map<String, Object> data = {
      'personnelEmail': personnelEmail,
      'startTime': _startTime.toString(),
      'stopTime': _stopTime.toString(),
    };

    List<String> stringRegistrations = [];
    for (Map<String, Object> registration in registrations) {
      stringRegistrations.add(registration.toString());
    }
    data['registrations'] = stringRegistrations.toString();

    List<String> stringTrack = [];
    for (LatLng coordinates in track) {
      stringTrack.add(
          "{latitude: ${coordinates.latitude}, longitude: ${coordinates.longitude}");
    }
    data['track'] = stringTrack.toString();

    return data.toString();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class TripDataManager {
  TripDataManager.start(
      {required this.farmId,
      required this.personnelEmail,
      required this.mapName}) {
    _startTime = DateTime.now();
  }

  final String farmId;
  final String personnelEmail;
  final String mapName;
  late final DateTime _startTime;
  DateTime? _stopTime;
  List<Map<String, Object>> registrations = [];
  List<LatLng> track = [];

  void stop() {
    _stopTime = DateTime.now();
  }

  void post() {
    if (_stopTime == null) {
      stop();
    }

    // --- TRIPS ---

    CollectionReference tripCollection =
        FirebaseFirestore.instance.collection('trips');
    DocumentReference tripDocument = tripCollection.doc();

    List<Map<String, double>> preparedTrack = [];

    for (LatLng coordinate in track) {
      preparedTrack.add(
          {'latitude': coordinate.latitude, 'longitude': coordinate.longitude});
    }

    tripDocument.set({
      'farmId': farmId,
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

  @override
  String toString() {
    Map<String, Object> data = {
      'farmId': farmId,
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

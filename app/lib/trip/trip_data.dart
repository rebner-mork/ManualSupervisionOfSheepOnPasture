import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

class TripDataManager {
  TripDataManager.start({required this.farm, required this.overseer}) {
    _startTime = DateTime.now();
  }

  late String farm;
  String overseer;
  late DateTime _startTime;
  late DateTime? _stopTime;
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
        FirebaseFirestore.instance.collection("trips");

    DocumentReference tripDocument = tripCollection.doc();

    List<Map<String, double>> preparedTrack = [];

    for (var element in track) {
      preparedTrack
          .add({'latitude': element.latitude, 'longitude': element.longitude});
    }

    tripDocument.set({
      'farmId': farm,
      'personnelId': overseer,
      'startTime': _startTime,
      'stopTime': _startTime,
      'track': preparedTrack,
    });

    // --- REGISTRATIONS ---

    CollectionReference registrationCollection =
        FirebaseFirestore.instance.collection("registrations");

    for (var element in registrations) {
      DocumentReference registrationDocument = registrationCollection.doc();
      element['tripId'] = tripDocument;
      registrationDocument.set(element);
    }
  }

  @override
  String toString() {
    Map<String, Object> data = {
      'farm': farm,
      'overseer': overseer,
      'startTime': _startTime.toString(),
      'stopTime': _stopTime.toString(),
    };

    List<String> stringRegistrations = [];
    registrations.forEach((element) {
      stringRegistrations.add(element.toString());
    });
    data['registrations'] = stringRegistrations.toString();

    List<String> stringTrack = [];
    track.forEach((element) {
      stringTrack.add(
          "{latitude: ${element.latitude}, longitude: ${element.longitude}");
    });
    data['track'] = stringTrack.toString();

    return data.toString();
  }
}

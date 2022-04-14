import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:path/path.dart' as path;

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
  List<Map<String, dynamic>> registrations = [];
  List<LatLng> track = [];

  void _storePhotos() {
    FirebaseStorage photoStorage = FirebaseStorage.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    final List<List<String>> fullPhotoUrls = [];
    final List<int> indexes = [];

    for (int i = 0; i < registrations.length; i++) {
      if (registrations[i].containsValue('cadaver') &&
          !registrations[i]['photos'].isEmpty) {
        fullPhotoUrls.add([]);
        indexes.add(i);
        for (int j = 0; j < registrations[i]['photos'].length; j++) {
          try {
            String basename = path.basename(registrations[i]['photos'][j]);
            Reference fileReference =
                photoStorage.ref('users/$uid/cadavers/$basename');
            fullPhotoUrls.last.add('users/$uid/cadavers/$basename');
            fileReference
                .putFile(File(registrations[i]['photos'][j]))
                .then((_) {
              File(registrations[i]['photos'][j]).deleteSync();
            });
          } on FirebaseException catch (e) {
            developer.log(e.toString());
          }
        }
      }
    }

    for (int registrationIndex in indexes) {
      registrations[registrationIndex]['photos'] = fullPhotoUrls.first;
      if (fullPhotoUrls.isNotEmpty) {
        fullPhotoUrls.removeAt(0);
      }
    }
  }

  void post() {
    _stopTime ??= DateTime.now();

    // --- PHOTOS ---

    _storePhotos();

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
    for (Map<String, dynamic> registration in registrations) {
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

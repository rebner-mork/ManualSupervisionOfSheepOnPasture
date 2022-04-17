import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:path/path.dart' as path;

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

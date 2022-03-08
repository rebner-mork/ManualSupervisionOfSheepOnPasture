import 'package:latlong2/latlong.dart';

class TripDataManager {
  TripDataManager.start({required this.farm, required this.overseer}) {
    _startTime = DateTime.now();
  }

  late String farm;
  String overseer;
  late DateTime _startTime;
  late DateTime? _stopTime;
  List<Object> registrations = [];
  List<LatLng> track = [];

  void post() {
    print("post");
  }

  @override
  String toString() {
    Map<String, Object> data = {
      'farm': farm,
      'overseer': overseer,
      'startTime': _startTime.toString(),
      //'stopTime': _stopTime == Null ? 'Null' : _stopTime.toString(),
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

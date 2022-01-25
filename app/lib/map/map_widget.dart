import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NorgesKart extends StatelessWidget {
  const NorgesKart({Key? key}) : super(key: key);

  final String mapType = 'topo4';

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(59.13, 10.21),
        zoom: 13.0,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://opencache{s}.statkart.no/gatekeeper/gk/gk.open_gmaps?layers=$mapType&zoom={z}&x={x}&y={y}",
          subdomains: ['', '2', '3'],
          attributionBuilder: (_) {
            return const Text("Kartverket");
          },
        ),
      ],
    );
  }
}

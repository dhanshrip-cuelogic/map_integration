import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const source = LatLng(18.4529, 73.8652);
const midpoint1 = LatLng(18.5018, 73.8636);
const midpoint2 = LatLng(18.5285, 73.8744);
const destination = LatLng(18.5335, 73.8778);

class MapApp extends StatefulWidget {
  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  GoogleMapController _controller;
  Set<Marker> _markers = {};
  String googleAPIKey = 'AIzaSyAEIC0EiyQoPpGbId_Yukqsh34zZ3CFTYU';

  void setMarkers() {
    print('----- Successfully added markers ------------');
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('source'),
          draggable: false,
          position: source,
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('midpoint1'),
          draggable: false,
          position: midpoint1,
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('midpoint2'),
          draggable: false,
          position: midpoint2,
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          draggable: false,
          position: destination,
        ),
      );
    });
  }

  void mapCreated(controller) {
    _controller = controller;
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: source,
        zoom: 12.0,
      ),
      markers: _markers,
      onMapCreated: mapCreated,
    );
  }
}

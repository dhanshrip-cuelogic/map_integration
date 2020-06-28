import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);

class MapApp extends StatefulWidget {
  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};

  Set<Polyline> _polylines = {};

  List<LatLng> polylineCoordinates = [];

  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPIKey = 'AIzaSyAEIC0EiyQoPpGbId_Yukqsh34zZ3CFTYU';

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/source_location.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_location.png');
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: SOURCE_LOCATION,
        icon: sourceIcon,
      ));
      // destination pin
      _markers.add(
        Marker(
          markerId: MarkerId('destPin'),
          position: DEST_LOCATION,
          icon: destinationIcon,
        ),
      );
    });
  }

  setPolylines() async {
    List<PointLatLng> result = (await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        SOURCE_LOCATION as PointLatLng,
        DEST_LOCATION as PointLatLng)) as List<PointLatLng>;
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId('poly'),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
      target: SOURCE_LOCATION,
      zoom: 11.0,
    );
//
//    CameraPosition(
//      zoom: CAMERA_ZOOM,
//      bearing: CAMERA_BEARING,
//      tilt: CAMERA_TILT,
//      target: SOURCE_LOCATION,
//    );

    return GoogleMap(
//      myLocationEnabled: true,
//      compassEnabled: true,
//      tiltGesturesEnabled: false,
//      markers: _markers,
//      polylines: _polylines,
//      mapType: MapType.normal,
      initialCameraPosition: initialLocation,
      onMapCreated: onMapCreated,
    );
  }
}

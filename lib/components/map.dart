import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


class Map extends StatefulWidget {

  LatLng location;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();

  Map({required this.location, required this.polylineCoordinates});

  @override
  MapState createState() => MapState(this.location, this.polylineCoordinates);

}

class MapState extends State<Map> {

  LatLng location;
  List<LatLng> polylineCoordinates = [];

  MapState(this.location, this.polylineCoordinates);


  @override
  Widget build(BuildContext context) {

    final Polyline polyline = Polyline(
        polylineId: PolylineId('line'),
        consumeTapEvents: true,
        color: Colors.red,
        width: 5,
        points: polylineCoordinates,
    );

    Set<Polyline> _polylines = {};
    _polylines.add(polyline);
    
    return ConstrainedBox(
        constraints: new BoxConstraints(
            maxHeight: 450,
        ),
        child: GoogleMap(
            initialCameraPosition: CameraPosition(
                target: start,
                zoom: 18,
            ),
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            polylines: _polylines,
        ),
    );
  }
}

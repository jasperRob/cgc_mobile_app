import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:math';
import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;

double myLat = -37.734722;
double myLong = 145.229721;

double teeLat = -37.734752;
double teeLong = 145.229737;

class ARTee extends StatefulWidget {

  Hole hole;
  Game game;

  ARTee({required this.hole, required this.game});

  @override
  ARTeeState createState() => ARTeeState();

}

class ARTeeState extends State<ARTee> {

  ARKitController? arkitController;
  ARKitPlane? plane;
  bool? anchorWasFound = false;
  double? _clearDirection = 0;
  double? distance = 0;
  int? _distance = 0;
  double? targetDegree = 0;
  Timer? timer;

  double getCoordinateAngle(double lat1, double long1, double lat2, double long2) {
    double dLon = (long2 - long1);

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double angle = atan2(y, x);

    angle = vector.degrees(angle);
    // angle = (angle + 360) % 360;
    //brng = 360 - brng; //remove to make clockwise
    return angle;
  }

  void calculateDegree() {
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        if (targetDegree != null && event != null) {
          _clearDirection = targetDegree;
          // _clearDirection = targetDegree - event.heading;
        }
      });
    });
  }

  void _getlocation() async {
    //if you want to check location service permissions use checkGeolocationPermissionStatus method
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print("MY POS: lat = " + position.latitude.toString() + ", long = " + position.longitude.toString());

    final double _teePositionLat = -37.734752;
    final double _teePositionLong = 145.229737;

    distance = await Geolocator.distanceBetween(position.latitude,
        position.longitude, _teePositionLat, _teePositionLong);

    print("Distance = " + distance.toString());

    targetDegree = getCoordinateAngle(position.latitude, position.longitude,
        _teePositionLat, _teePositionLong);

    print("Angle = " + targetDegree.toString());
    calculateDegree();
  }

  @override
  void initState() {
    super.initState();
    _getlocation();
    timer = new Timer.periodic(Duration(seconds: 5), (timer) {
      _getlocation();
    });
  }

  @override
  void dispose() {
    arkitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Virtual Tee')),
      body: ARKitSceneView(
          onARKitViewCreated: onARKitViewCreated,
          // planeDetection: ARPlaneDetection.horizontal,
          ));

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController?.onAddNodeForAnchor = onAnchorWasFound;
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
        //if you want to block AR while you aren't close to target > add "if (situationDistance==WidgetDistance.ready)" here
      setState(() => anchorWasFound = true);
      print("ANCHOR FOUND!!!!!!!!!!!!!!!!");

      plane = ARKitPlane(
          width: 0.5,
          height: 0.5,
          materials: [
            ARKitMaterial(
                transparency: 0.5,
                diffuse: ARKitMaterialProperty.color(Colors.white),
            )
          ],
      );

      final targetPosition = anchor.transform.getColumn(3);
      final node = ARKitNode(
          geometry: plane,
          position: vector.Vector3(
              targetPosition.x, targetPosition.y, targetPosition.z),
          eulerAngles: vector.Vector3.zero(),
      );
      this.arkitController?.add(node);

    }
  }


  // void onARKitViewCreated(ARKitController arkitController) {
  //   this.arkitController = arkitController;
  //   // final node = ARKitNode(
  //   //     geometry: ARKitSphere(radius: 0.1), position: vector.Vector3(0, 0, -0.5));
  //   // this.arkitController.add(node);

  //   double gain = 50000;

  //   double difLat = (teeLat - myLat) * gain;
  //   double difLong = (teeLong - myLong) * gain;

  //   plane = ARKitPlane(
  //     width: 0.5,
  //     height: 0.5,
  //     materials: [
  //       ARKitMaterial(
  //         transparency: 0.5,
  //         diffuse: ARKitMaterialProperty.color(Colors.white),
  //       )
  //     ],
  //   );

  //   final node = ARKitNode(
  //       geometry: plane,
  //       position: vector.Vector3(-difLat, -0.5, -difLong),
  //       rotation: vector.Vector4(1, 0, 0, -math.pi / 2),
  //   );
  //   this.arkitController.add(node);
  // }

}

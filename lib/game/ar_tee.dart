import 'dart:async';
import 'dart:math';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:geolocator/geolocator.dart';

class ARTee extends StatefulWidget {
  @override
  ARTeeState createState() => ARTeeState();
}

enum WidgetDistance { ready, navigating }
enum WidgetCompass { scanning, directing }

class ARTeeState extends State<ARTee> {
  WidgetDistance situationDistance = WidgetDistance.navigating;
  WidgetCompass situationCompass = WidgetCompass.directing;

  late ARKitController arkitController;
  bool anchorWasFound = false;
  int _clearDirection = 0;
  double distance = 0;
  int _distance = 0;
  double targetDegree = 0;
  late Timer timer;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  //calculation formula of angel between 2 different points
  double angleFromCoordinate(
      double lat1, double long1, double lat2, double long2) {
    double dLon = (long2 - long1);

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double brng = atan2(y, x);

    brng = vector.degrees(brng);
    brng = (brng + 360) % 360;
    //brng = 360 - brng; //remove to make clockwise
    return brng;
  }


  //device compass
  void calculateDegree() async {
    final CompassEvent event = await FlutterCompass.events!.first;
    setState(() {
      if (targetDegree != null && event != null) {
        _clearDirection = targetDegree.truncate() - event.heading!.truncate();
      }
    });
  }

  //distance between faculty and device coordinates
  void _getlocation() async {
    //if you want to check location service permissions use checkGeolocationPermissionStatus method
    Position position = await _geolocatorPlatform
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final double _facultypositionlat = -37.734666;
    final double _facultypositionlong = 145.229741;

    distance = await _geolocatorPlatform.distanceBetween(position.latitude,
        position.longitude, _facultypositionlat, _facultypositionlong);

    targetDegree = angleFromCoordinate(position.latitude, position.longitude,
        _facultypositionlat, _facultypositionlong);
    calculateDegree();
  }

  @override
  void initState() {
    super.initState();
    _getlocation(); //first run
    timer = new Timer.periodic(Duration(seconds: 3), (timer) {

      print("DISTANCE = " + distance.toString());

      _getlocation();
      if (distance < 0.5 && distance != 0 && distance != null) {
        setState(() {
          situationDistance = WidgetDistance.ready;
          situationCompass = WidgetCompass.scanning;
        });
      } else {
        setState(() {
          _distance = distance.truncate();
          situationDistance = WidgetDistance.navigating;
          situationCompass = WidgetCompass.directing;
        });
      }
    });
  }

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Virtual Tee'),
        // flexibleSpace: Container(
        //   decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //           colors: <Color>[
        //         Color.fromARGB(190, 207, 37, 7),
        //         Colors.transparent
        //       ])),
        // ),
      ),
      body: ARKitSceneView(
        onARKitViewCreated: onARKitViewCreated,
      ),
      // body: distanceProvider(),
      // floatingActionButton: compassProvider());
    );

  Widget readyWidget() {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ARKitSceneView(
            detectionImagesGroupName: 'AR Resources',
            onARKitViewCreated: onARKitViewCreated,
          ),
          anchorWasFound
              ? Container()
              : Column(
                  //do something here...
                  ),
        ],
      ),
    );
  }

  Widget navigateWidget() {
    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ARKitSceneView(
            detectionImagesGroupName: 'AR Resources',
            onARKitViewCreated: onARKitViewCreated,
          ),
          anchorWasFound
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('$_distance m.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.blueGrey,
                              color: Colors.white)),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget scanningWidget() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: null,
      child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.lightBlue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.white,
            onPressed: () {},
          )),
    );
  }

  Widget directingWidget() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: null,
      child: RotationTransition(
        turns: new AlwaysStoppedAnimation(_clearDirection > 0
            ? _clearDirection / 360
            : (_clearDirection + 360) / 360),
        //if you want you can add animation effect for rotate
        child: Ink(
          decoration: const ShapeDecoration(
            color: Colors.lightBlue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_upward),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget compassProvider() {
    switch (situationCompass) {
      case WidgetCompass.scanning:
        return scanningWidget();
      case WidgetCompass.directing:
        return directingWidget();
    }
    return directingWidget();
  }

  Widget distanceProvider() {
    switch (situationDistance) {
      case WidgetDistance.ready:
        return readyWidget();
      case WidgetDistance.navigating:
        return navigateWidget();
    }
    return navigateWidget();
  }

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    // this.arkitController.onAddNodeForAnchor = onAnchorWasFound;


    const teeScale = 0.01;
    final tee = ARKitNode(
      geometry: ARKitText(
        text: "Tee",
        extrusionDepth: 1,
        materials: [
          ARKitMaterial(
              diffuse: ARKitMaterialProperty.color(Colors.red),
          )
        ],
      ),
      position: vector.Vector3(0.5, 0, -2),
      rotation: vector.Vector4(0, 0, -pi / 2, 0),
      scale: vector.Vector3(teeScale, teeScale, teeScale),
    );

    final teePoint = ARKitNode(
        geometry: ARKitSphere(radius: 0.1), position: vector.Vector3(0, 0, -2));

    // final teePoint = ARKitNode(
    //   geometry: ARKitPyramid(
    //     height: 10,
    //     width: 10,
    //     length: 10,
    //     materials: [
    //       ARKitMaterial(
    //           diffuse: ARKitMaterialProperty.color(Colors.red),
    //       )
    //     ],
    //   ),
    //   position: vector.Vector3(0, -1, -30),
    //   rotation: vector.Vector4(0, 0, 0, pi),
    // );

    const holeScale = 2.0;

    final hole = ARKitNode(
      geometry: ARKitText(
        text: "Hole",
        extrusionDepth: 1,
        materials: [
          ARKitMaterial(
              diffuse: ARKitMaterialProperty.color(Colors.red),
          )
        ],
      ),
      position: vector.Vector3(-50, 0, -500),
      rotation: vector.Vector4(0, 0, -pi / 2, 0),
      // scale: vector.Vector3(holeScale, holeScale, holeScale),
    );
        // geometry: ARKitSphere(radius: 0.1), position: Vector3(0, 0, -0.5));
    this.arkitController.add(tee);
    // this.arkitController.add(teePoint);
    this.arkitController.add(hole);
  }

  //void onAnchorWasFound(ARKitAnchor anchor) {
  //  Type type = anchor.runtimeType;
  //  print("%%%%%%%%%%%%%%%%%%%%  Anchor Type = " + type.toString());
  //  if (anchor is ARKitImageAnchor) {
  //      //if you want to block AR while you aren't close to target > add "if (situationDistance==WidgetDistance.ready)" here
  //    setState(() => anchorWasFound = true);
  //    print("ANCHOR FOUND **********************************");

  //    final materialCard = ARKitMaterial(
  //      lightingModelName: ARKitLightingModel.lambert,
  //      diffuse: ARKitMaterialImage('marnong_estate_header_logo.png'),
  //    );

  //    final image =
  //        ARKitPlane(height: 0.4, width: 0.4, materials: [materialCard]);

  //    final targetPosition = anchor.transform.getColumn(3);
  //    final node = ARKitNode(
  //      geometry: image,
  //      position: vector.Vector3(
  //          targetPosition.x, targetPosition.y, targetPosition.z),
  //      eulerAngles: vector.Vector3.zero(),
  //    );
  //    arkitController.add(node);
  //  }
  //}
}

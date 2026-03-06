import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';
import '../services/firestore_service.dart';
import '../services/geofence_service.dart';

class ChildMapScreen extends StatefulWidget {
  const ChildMapScreen({super.key});

  @override
  State<ChildMapScreen> createState() => _ChildMapScreenState();
}

class _ChildMapScreenState extends State<ChildMapScreen> {

  final LocationService locationService = LocationService();
  final FirestoreService firestoreService = FirestoreService();
  final GeofenceService geofenceService = GeofenceService();

  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    startTracking();
  }

  void startTracking() {

    Timer.periodic(const Duration(seconds: 5), (timer) async {

      var pos = await locationService.getCurrentLocation();

      setState(() {
        currentLocation = LatLng(pos.latitude, pos.longitude);
      });

      /// Update child location in Firestore
      await firestoreService.updateChildLocation(
        "child1",
        pos.latitude,
        pos.longitude,
      );

      /// Get geofence
      var geofenceDoc = await firestoreService.getGeofence("child1");

      if (geofenceDoc.exists) {

        var data = geofenceDoc.data() as Map<String, dynamic>;

        bool outside = geofenceService.isOutsideGeofence(
          pos.latitude,
          pos.longitude,
          data["centerLat"],
          data["centerLng"],
          data["radius"],
        );

        if (outside) {
          print("Child left geofence!");
        }

      }

    });

  }

  @override
  Widget build(BuildContext context) {

    if (currentLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Child Location")),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: currentLocation!,
          initialZoom: 16,
        ),
        children: [

          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),

          MarkerLayer(
            markers: [
              Marker(
                point: currentLocation!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentLiveMap extends StatelessWidget {
  const ParentLiveMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Child Live Location"),
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("children")
            .doc("child1")
            .snapshots(),

        builder: (context, snapshot) {

          /// Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// No data yet
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Waiting for child location..."),
            );
          }

          /// Extract data
          var data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data == null ||
              !data.containsKey("lat") ||
              !data.containsKey("lng")) {

            return const Center(
              child: Text("Location not available yet"),
            );
          }

          /// Convert to LatLng
          LatLng childLocation = LatLng(
            data["lat"],
            data["lng"],
          );

          /// Map UI
          return FlutterMap(
            options: MapOptions(
              initialCenter: childLocation,
              initialZoom: 16,
            ),

            children: [

              /// OpenStreetMap tiles
              TileLayer(
                urlTemplate:
                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.childsafety',
              ),

              /// Child marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: childLocation,
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.child_care,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

            ],
          );
        },
      ),
    );
  }
}
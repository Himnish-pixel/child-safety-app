import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/notification_service.dart';
import 'parent_live_map.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    saveFCMToken();
  }

  Future<void> saveFCMToken() async {

    final notificationService = NotificationService();

    String? token = await notificationService.getToken();

    if (token != null) {

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "fcmToken": token
      });

      print("Parent FCM Token saved");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard"),
        actions: [

          /// Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
            },
          )

        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,

          children: [

            /// Live Location
            _dashboardCard(
              context,
              "Child Live Map",
              Icons.location_on,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParentLiveMap(),
                  ),
                );
              },
            ),

            /// Geofence
            _dashboardCard(
              context,
              "Geofence Manager",
              Icons.map,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Geofence feature coming soon"),
                  ),
                );
              },
            ),

            /// Stop Alerts
            _dashboardCard(
              context,
              "Stop Alerts",
              Icons.pause_circle,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Stop alerts coming soon"),
                  ),
                );
              },
            ),

            /// Route Monitoring
            _dashboardCard(
              context,
              "Route Monitor",
              Icons.alt_route,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Route monitoring coming soon"),
                  ),
                );
              },
            ),

            /// Emergency Alerts
            _dashboardCard(
              context,
              "Emergency Alerts",
              Icons.warning,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Emergency alerts coming soon"),
                  ),
                );
              },
            ),

            /// Manage Children
            _dashboardCard(
              context,
              "Manage Children",
              Icons.child_care,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Child management coming soon"),
                  ),
                );
              },
            ),

            /// Settings
            _dashboardCard(
              context,
              "Settings",
              Icons.settings,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Settings coming soon"),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  /// Dashboard Card Widget
  Widget _dashboardCard(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blue.withOpacity(0.1),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )

          ],
        ),
      ),
    );
  }
}
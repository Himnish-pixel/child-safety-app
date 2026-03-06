import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'child_map_screen.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Child Dashboard"),
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
              "Live Location",
              Icons.location_on,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChildMapScreen(),
                  ),
                );
              },
            ),

            /// Geofence
            _dashboardCard(
              context,
              "Geofence Status",
              Icons.map,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Geofence feature coming soon"),
                  ),
                );
              },
            ),

            /// Stop Detection
            _dashboardCard(
              context,
              "Stop Detection",
              Icons.pause_circle,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Stop detection coming soon"),
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

            /// Panic Button
            _dashboardCard(
              context,
              "Panic Button",
              Icons.warning,
              () async {

                final notificationService = NotificationService();

                String childId = FirebaseAuth.instance.currentUser!.uid;

                // Get parent user
                QuerySnapshot parentQuery = await FirebaseFirestore.instance
                    .collection("users")
                    .where("role", isEqualTo: "parent")
                    .get();

                if (parentQuery.docs.isNotEmpty) {

                  String parentToken = parentQuery.docs.first["fcmToken"];

                  await notificationService.sendPushNotification(parentToken);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🚨 Panic alert sent to parent"),
                    ),
                  );

                } else {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No parent found"),
                    ),
                  );

                }

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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirestoreService {


  Future<void> setGeofence(
  String childId,
  double lat,
  double lng,
  double radius,
) async {

  await _db.collection("geofences").doc(childId).set({
    "centerLat": lat,
    "centerLng": lng,
    "radius": radius,
  });

}

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Update child GPS location
  Future<void> updateChildLocation(
    String childId,
    double lat,
    double lng,
  ) async {

    await _db.collection("children").doc(childId).set({
      "lat": lat,
      "lng": lng,
      "timestamp": FieldValue.serverTimestamp(),
    });

  }
  Future<DocumentSnapshot> getGeofence(String childId) async {

  return await _db.collection("geofences").doc(childId).get();

}

  /// Store panic alert in Firestore
  Future<void> sendEmergencyAlert(String childId) async {

    await _db.collection("alerts").add({
      "childId": childId,
      "type": "panic",
      "timestamp": FieldValue.serverTimestamp(),
      "status": "active",
    });

  }

  /// Send push notification to parent device
  Future<void> sendPushNotification(String token) async {

    const String serverKey = "YOUR_FIREBASE_SERVER_KEY";

    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=$serverKey",
      },
      body: jsonEncode({
        "to": token,
        "notification": {
          "title": "🚨 Panic Alert",
          "body": "Your child triggered an emergency alert!"
        },
        "data": {
          "type": "panic"
        }
      }),
    );

  }

}

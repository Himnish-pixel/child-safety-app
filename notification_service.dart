import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Get device FCM token
  Future<String?> getToken() async {

    await _messaging.requestPermission();

    String? token = await _messaging.getToken();

    print("FCM Token: $token");

    return token;
  }

  /// Send push notification
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
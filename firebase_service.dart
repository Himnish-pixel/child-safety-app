import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

}

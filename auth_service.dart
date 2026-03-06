import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {

    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return result.user;
  }

  Future<User?> register(
      String email,
      String password,
      String role,
  ) async {

    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;

    if (user != null) {
      await _db.collection("users").doc(user.uid).set({
        "email": email,
        "role": role,
      });
    }

    return user;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
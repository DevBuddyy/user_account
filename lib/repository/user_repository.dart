import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_account/firebase_options.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getUserInfo() async {
    final user = _auth.currentUser;

    if (user != null) {
      final document = await _firestore.collection('users').doc(user.uid).get();
      return document['fullName'];
    } else {
      return null;
    }
  }

  Future<void> saveUserInfo(String fullName) async {
    final user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({'fullName': fullName});
    }
  }

  getUserName() {}
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:user_account/screens/user.dart' as local_user;

class DatabaseService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(local_user.User user) async {
    await _usersCollection.doc(user.id).set({
      'firstName': user.firstName,
      'middleName': user.middleName,
      'lastName': user.lastName,
    });
  }

  Future<local_user.User?> getUser(String userId) async {
    var snapshot = await _usersCollection.doc(userId).get();
    if (snapshot.exists) {
      return local_user.User(
        id: userId,
        firstName: snapshot['firstName'],
        middleName: snapshot['middleName'],
        lastName: snapshot['lastName'],
      );
    }
    return null;
  }
}

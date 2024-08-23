import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/userProfile.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserProfile?> getUser(String userId) async {
    try {
      final doc = await _db.collection('profiles').doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Stream<UserProfile?> streamUser(String userId) {
    return _db.collection('profiles').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserProfile.fromFirestore(doc);
      } else {
        return null;
      }
    });
  }

  Future<void> updateUser(String userId, UserProfile profile) async {
    try {
      await _db.collection('profiles').doc(userId).set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> addUser(String name, String email) async {
    try {
      await _db.collection('users').add({
        'name': name,
        'email': email,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('User added successfully');
    } catch (e) {
      print('Failed to add user: $e');
    }
  }

  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return User.fromFirestore(doc);
      }).toList();
    });
  }
}

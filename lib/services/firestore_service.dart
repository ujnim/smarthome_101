import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_home101/models/userProfile.dart';

class FireBaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('profiles').doc(userId).get();
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

  Future<void> create(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      print('$collection created successfully');
    } catch (e) {
      print('Failed to create in $collection: $e');
    }
  }

  Future<void> update(String collection, String documentId,
      Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection(collection)
          .doc(documentId)
          .update(updatedData);
      print('$collection updated successfully');
    } catch (e) {
      print('Failed to update in $collection: $e');
    }
  }

  Future<void> delete(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      print('$collection deleted successfully');
    } catch (e) {
      print('Failed to delete in $collection: $e');
    }
  }

  // Group for managing home data
  HomeController get home => HomeController(_firestore);
  ProfileController get profile => ProfileController(_firestore);
}

class ProfileController {
  final FirebaseFirestore _firestore;
  ProfileController(this._firestore);

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('profiles').doc(userId).get();
      if (doc.exists) {
        // Convert the document data to a map and return it
        return doc.data() as Map<String, dynamic>?;
      } else {
        print('Profile for user $userId does not exist.');
        return null;
      }
    } catch (e) {
      print('Failed to get profile: $e');
      return null;
    }
  }
}

class HomeController {
  final FirebaseFirestore _firestore;

  HomeController(this._firestore);

  Future<int> getHomeCountByUser(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('homes')
          .where('owner', isEqualTo: userId)
          .get();

      int count = querySnapshot.size;
      print('Number of homes for user $userId: $count');
      return count;
    } catch (e) {
      print('Failed to get home count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getHomesByOwner(String ownerId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('homes')
          .where('owner', isEqualTo: ownerId)
          .get();

      List<Map<String, dynamic>> homes = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['homeId'] = doc.id; // เพิ่ม documentId เข้าไปใน Map
        return data;
      }).toList();

      print('Homes for owner $ownerId: $homes');
      return homes;
    } catch (e) {
      print('Failed to get homes: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getHomesById(String homeId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('homes')
          .where(FieldPath.documentId, isEqualTo: homeId)
          .get();

      List<Map<String, dynamic>> homes = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      print('Homes for ID $homeId: $homes');
      return homes;
    } catch (e) {
      print('Failed to get homes: $e');
      return [];
    }
  }
}

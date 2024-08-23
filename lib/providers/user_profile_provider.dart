import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_home101/models/userProfile.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  Future<void> fetchUserProfile(String userId) async {
    // ดึงข้อมูลจาก Firestore
    final doc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();
    _userProfile = UserProfile.fromFirestore(doc);
    print(_userProfile);
    notifyListeners(); // แจ้งให้ผู้ที่ใช้ Provider ทราบว่ามีการอัพเดทข้อมูล
  }

  void updateUserProfile(UserProfile newProfile) {
    _userProfile = newProfile;
    notifyListeners();
  }
}

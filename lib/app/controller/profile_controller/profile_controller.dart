
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  /// Stream for real-time user profile updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> get userProfileStream {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots();
  }

  /// Update local observables from Firestore snapshot
  void updateFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data != null) {
      name.value = data['name'] ?? '';
      email.value = data['email'] ?? '';
      phone.value = data['phone'] ?? '';
    }
  }

  /// Optional: update profile in Firestore
  Future<void> updateProfileInFirestore({
    required String newName,
    required String newPhone,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
        'phone': newPhone,
      });
    }
  }

  /// Local-only update (used before Firestore is called)
  void updateProfileLocally({
    required String newName,
    required String newEmail,
    required String newPhone,
  }) {
    name.value = newName;
    email.value = newEmail;
    phone.value = newPhone;
  }
}

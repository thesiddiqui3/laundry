import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
  }) async {
    final userRef = _db.collection('users').doc(uid);

    // Check if user already exists to avoid overwriting
    final doc = await userRef.get();
    if (!doc.exists) {
      await userRef.set({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

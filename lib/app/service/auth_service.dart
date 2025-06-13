import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:laundry/app/service/firestore_service/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Don't let Firestore failure affect login
        try {
          await FirestoreService().createUserProfile(
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
          );
        } catch (e) {
          print("⚠️ Firestore Save Error: $e");
        }
      }

      return user;
    } catch (e) {
      print("❌ Google Sign-In Error: $e");
      return null;
    }
  }


  // Optionally, add logout
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authChanges => _auth.authStateChanges();
}

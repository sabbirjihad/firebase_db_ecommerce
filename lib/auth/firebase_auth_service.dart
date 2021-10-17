import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bitm12/db/FirestoreHelper.dart';

class FirebaseAuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<bool> isCurrentUserAdmin(String uid) async {
    final count = await FirestoreHelper.checkForAdminValidity(uid);
    return count == 0 ? false : true;
  }

  static Future<String?> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user?.uid;
  }

  static Future<String?> registerUser(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user?.uid;
  }

  static Future<void> logout() {
    return _auth.signOut();
  }
}
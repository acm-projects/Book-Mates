import 'package:firebase_auth/firebase_auth.dart';

// this class's function is purely for user authentication when signing in, out, and creating a new registery
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges(); // flag for when we recieve an authenticated user, will be null if not

  Future<void> signInWithEmailAndPassword({// to sign in a user
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({ // to create a new user
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password);
  }

  Future<void> signOut() async { // to sign out a user
    await _firebaseAuth.signOut(); 
  }

  // Future<void> convert(User? user) async {}
}

import 'package:firebase_auth/firebase_auth.dart';

// this class's function is purely for user authentication when signing in, out, and creating a new registery
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth
      .authStateChanges(); // flag for when we recieve an authenticated user, will be null if not
}

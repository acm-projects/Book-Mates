import 'package:firebase_auth/firebase_auth.dart';

// this class's function is purely for user authentication when signing in, out, and creating a new registery
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth
      .authStateChanges(); // flag for when we recieve an authenticated user, will be null if not

  Future<void> signInWithEmailAndPassword({
    // a this signs in a user, with the params being required, async bc were using the FirebaseAuth classes method, which communicates with the firebase server, so we cant move on until will complete this function fully
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    //the funciton takes 2 'required' params, email and password
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        //have async bc the _firebaseAuth class, FirebaseAuth, is contacting the firebase server, and is running on its own time, cannot move on until this is fininshed
        email: email,
        password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth
        .signOut(); //wait bc _firebasAuth is talking to firebase servers
  }

  Future<void> convert(User? user) async {}
}

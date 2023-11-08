import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  // this is the shape of data firestore contains in digestable form

  final String? id;
  final String? username;
  final String? email;
  final String passsword;

  UserModel(
      {this.username, this.email, required this.id, required this.passsword});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    // when fetching data from firestore, this turns it into object form
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['Email'],
      id: snapshot['id'],
      passsword: snapshot["Password"],
      username: snapshot['userName'],
    );
  }

  Map<String, dynamic> toJson() => {
        // turns object data in form firestore can understand
        "userName": username,
        "Password": passsword,
        "id": id,
        "Email": email,
      };

  // to return the userName of the current user
  Future<String?> getUserName() async {
    // get the email
    final email = FirebaseAuth.instance.currentUser?.email;
    // get snapshot of user's firestore reference
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    return userSnapshot.data()!['userName'];
  }
}

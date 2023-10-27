import 'package:bookmates_app/User%20Implementation/user_model.dart';
import 'package:bookmates_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this class manages the firestore database
// the ID of every document in the 'users' collection is the user's email that was used to register

class UserRepo {
  static Future create(UserModel user) async {
    // creates a user in firestore

    final userCollection = FirebaseFirestore.instance.collection("users");

    final userEmail = Auth().currentUser?.email;

    final docRef = userCollection.doc(userEmail);

    final newUser = UserModel(
      id: userEmail,
      email: user.email,
      passsword: user.passsword,
      username: user.username,
    ).toJson();

    await docRef.set(newUser);

    await FirebaseFirestore.instance
        .collection('users/$userEmail/Groups')
        .doc()
        .set({
      // this creates the subcollection 'Groups' in a document of 'users'
    });
    await FirebaseFirestore.instance
        .collection('users/$userEmail/Library')
        .doc()
        .set({});
    await FirebaseFirestore.instance
        .collection('users/$userEmail/Library')
        .doc()
        .set({});
  }
}

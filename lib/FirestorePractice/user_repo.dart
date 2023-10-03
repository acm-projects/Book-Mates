import 'package:bookmates_app/FirestorePractice/user_model.dart';
import 'package:bookmates_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this class manages the firestore database


class UserRepo {

  static Stream<List<UserModel>> read() { // lists out all the users in the document
    final userCollection = FirebaseFirestore.instance.collection("users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  static Future create(UserModel user) async { // creates a user in firestore
    final userCollection = FirebaseFirestore.instance.collection("users");

    final uid = Auth().currentUser?.email; // the id of each document in firestore is the email the user used to sign in
    
    final docRef = userCollection.doc(uid); // refrence of the specific document we want to put data into

    final newUser = UserModel(
      id: uid,
      email: user.email,
      passsword: user.passsword,
      username: user.username,
    ).toJson();

    try {
      await docRef.set(newUser);
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future update(UserModel user) async { // updates firestore data

    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef = userCollection.doc(user.id); // document refrence of the document wanted 

    final newUser = UserModel( // convert the userModel data into type Map<String, dynamic> (type of data in firestore)
      id: user.id,
      email: user.email,
      passsword: user.passsword,
      username: user.username,
    ).toJson();

    try {
      await docRef.update(newUser);
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future delete(UserModel user) async { // deleting a user from firestore
    final userCollection = FirebaseFirestore.instance.collection("users"); // user collectionReference

    userCollection.doc(user.id).delete(); // delete that user from firestore
  }
}

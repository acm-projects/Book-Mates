import 'package:bookmates_app/User%20Implementation/user_model.dart';
import 'package:bookmates_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this class manages the firestore database
// the ID of every document in the 'users' collection is the user's email that was used to register

class UserRepo {

  // static Stream<List<UserModel>> read() {// lists out all the users in the document
  //   final userCollection = FirebaseFirestore.instance.collection("users");

  //   return userCollection.snapshots().map((querySnapshot) =>
  //       querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  // }

  static Future create(UserModel user) async {// creates a user in firestore

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

    await FirebaseFirestore.instance.collection('users/$userEmail/Groups').doc().set({ // this creates the subcollection 'Groups' in a document of 'users' 
     
    });
  }

  static Future update(UserModel user) async { // for updating any data fields in any document of user, unused for now...

    final userCollection = FirebaseFirestore.instance.collection("users");

    final docRef =userCollection.doc(user.id); // document refrence of the document wanted

    final newUser = UserModel(
      // convert the userModel data into type Map<String, dynamic> (type of data in firestore)
      id: user.id,
      email: user.email,
      passsword: user.passsword,
      username: user.username,
    ).toJson();

    await docRef.update(newUser);
  }

  // static Future delete(UserModel user) async {// deleting a user from firestore, unused for now

  //   final userCollection = FirebaseFirestore.instance.collection("users"); 

  //   userCollection.doc(user.id).delete();
  // }
  
}

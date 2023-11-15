import 'package:cloud_firestore/cloud_firestore.dart';

// manages the firestore database for the 'users' collection

Future<void> createUser(String userName, password, String? email) async {
  // reference to a docuemnt that will store a users data upon registering
  final docRef = FirebaseFirestore.instance.collection('users').doc(email);

  //the data fields of a single user in the firestore database
  await docRef.set({
    'userName': userName,
    'Email': email,
    'Password': password,
    'profPicURL': "https://firebasestorage.googleapis.com/v0/b/bookma-d79ce.appspot.com/o/question.jpg?alt=media&token=f62ba153-6a1f-40d1-8db5-5e6cc6394a62",
  });
}

Future<void> joinGroup(String userEmail, groupID, groupName) async {
  //CRUD the subcollection 'Groups
  final userDocRef =
      FirebaseFirestore.instance.collection('users').doc(userEmail);

  await userDocRef.set({
    // updates the current group the user is in
    'currentGroupID': groupID,
  }, SetOptions(merge: true));

  // creating a new document in Groups subcollection
  final groupRef =
      FirebaseFirestore.instance.collection('users/$userEmail/Groups');

  await groupRef.doc(groupID).set({
    'groupID': groupID,
    'groupName': groupName,
  });
}

Future<void> leaveGroup(String userEmail, groupID) async {
  // get the refrence of the group we want delete in the subcollection of 'Groups'
  final userDocRef = FirebaseFirestore.instance
      .collection('users/$userEmail/Groups')
      .doc(groupID);

  await userDocRef.delete();

  // make the user's current group deleted, need to navigate to homepage or
  //join a group to get field back

  await FirebaseFirestore.instance.collection('users').doc(userEmail).set({
    'currentGroupID': FieldValue.delete(),
  }, SetOptions(merge: true));
}

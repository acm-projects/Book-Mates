import 'dart:io';

import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

// manages the firestore database for the 'users' collection

Future<void> createUser(String userName, password, String? email) async {
  // reference to a docuemnt that will store a users data upon registering
  final docRef = FirebaseFirestore.instance.collection('users').doc(email);

  //the data fields of a single user in the firestore database
  await docRef.set({
    'userName': userName,
    'Email': email,
    'Password': password,
    'profPicURL':
        "https://firebasestorage.googleapis.com/v0/b/bookma-d79ce.appspot.com/o/question.jpg?alt=media&token=f62ba153-6a1f-40d1-8db5-5e6cc6394a62",
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

Future<File?> pickProfPic() async {
  FilePickerResult? mediaUp =
      await FilePicker.platform.pickFiles(type: FileType.media);
  if (mediaUp != null && mediaUp.files.isNotEmpty) {
    File selectedFile = File(mediaUp.files.single.path!);
    return selectedFile;
  }
}

Future<void> uploadProfPic() async {
  final mediaFile = await pickProfPic();
  final email = FirebaseAuth.instance.currentUser?.email;
  String? groupID = await getCurrentGroupID();
  // need to get the file extension type 'pdf, jpg, etc'
  String fileExtension = mediaFile!.path.split('.').last;
  String filePath =
      'users/$email/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

  Reference storageReference = FirebaseStorage.instance.ref().child(filePath);
  UploadTask uploadTask = storageReference.putFile(mediaFile);

  //wait for upload to finish to download url
  await uploadTask.whenComplete(() async {
    String downloadUrl = await storageReference.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'profPicURL': downloadUrl,
    }, SetOptions(merge: true));

    // await FirebaseFirestore.instance
    //     .collection('groups/$groupID/Members')
    //     .doc(email)
    //     .set({'profPicURL': downloadUrl}, SetOptions(merge: true));

    // Update profPicURL for each group a user is in

    // get the reference of the groups subcollection of a user
    final userGroupsRef =
        FirebaseFirestore.instance.collection('users/$email/Groups');

    // get the data
    final userGroupsSnapshot = await userGroupsRef.get();

    for (var groupDoc in userGroupsSnapshot.docs) {
      // get the 'id' of every group a user is in
      final groupID = groupDoc['groupID'];
      // make a reference to the group you need to change the users profPic
      final groupMembersRef =
          FirebaseFirestore.instance.collection('groups/$groupID/Members');

      // make reference to the doc in Members that the user's in
      final memberDoc = await groupMembersRef.doc(email).get();

      // check if it exists, then update the data field
      if (memberDoc.exists) {
        // Update profPicURL for the member in the group
        await groupMembersRef.doc(email).set(
          {'profPicURL': downloadUrl},
          SetOptions(merge: true),
        );
      }
    }
  });
}

// to return the data fields of a user in Firestore
Future<Map<String, dynamic>?> getUserData() async {
  final email = FirebaseAuth.instance.currentUser?.email;
  final userRef =
      await FirebaseFirestore.instance.collection('users').doc(email).get();

  return userRef.data();
}

// to return the length of a subcollection in user
Future<int> getSubcollectionCount(String path) async {
  final subPathRef = await FirebaseFirestore.instance.collection(path).get();
  return subPathRef.docs.length;
}

Future<List<int>> getCountSub() async {
  final email = FirebaseAuth.instance.currentUser?.email;
  final userGroupRef =
      await FirebaseFirestore.instance.collection('users/$email/Groups').get();
  final userBookRef = await FirebaseFirestore.instance
      .collection('users/$email/BookPDFs')
      .get();
  return [
    userGroupRef.docs.length,
    userBookRef.docs.length,
  ];
}

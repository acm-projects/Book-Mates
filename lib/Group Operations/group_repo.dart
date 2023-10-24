import 'package:bookmates_app/Group%20Operations/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//this class manages all CRUD operations in firestore for the collection 'groups' as well as its subcollections 'Messages', 'Members' and 'Milestones'

// the docID of every group document will b the ID the user types in
// the id of every Member and Message document will be the email of the user who instantiates / updated it
// we use the 'async' and 'await' keywords because the code is contacting Firestore servers, the runtime is asyncronous with the compile time of our code

class GroupRepo {
  static int mileStoneCount =
      1; // will be the id of every milestone subcollection

  static Future msgAdd(
      {required String path,
      userEmail,
      msgContent,
      String? type,
      mediaURL}) async {
    //   CU/CRUD the Message subcollection in a document of the groups collection
    final db = FirebaseFirestore.instance;

    await db.collection(path).doc().set({
      "timeStamp": DateTime.now(),
      "text": msgContent,
      "senderID": userEmail,
      "mediaURL": mediaURL ?? "",
      "type": type ?? 'text',
    });
  }

  static Future memAdd(String path, userEmail, int admin) async {
    //    CU / CRUD the 'Members' subcollection (nested in 'groups' collection)
    final db = FirebaseFirestore.instance;

    await db.collection(path).doc(userEmail).set({
      "Member": userEmail,
      "isAdmin": admin == 1 ? true : false,
    });
  }

  static Future groupAdd(String path, String userEmail, String groupid) async {
    //  CU / CRUD the 'Groups' subcollection in 'users'
    final db = FirebaseFirestore.instance;

    await db.collection(path).doc(groupid).set({
      "groupdID": groupid,
    });

    await db.collection('users').doc(userEmail).set({
      // updates the current group the user is in
      'currentGroupID': groupid,
    }, SetOptions(merge: true));
  }

  static Future milestoneAdd(
      String path, String userEmail, String groupid) async {
    //  CU / CRUD the 'Milestone' subcollection in 'users'
    final db = FirebaseFirestore.instance;

    await db.collection(path).doc(mileStoneCount.toString()).set({
      "Milestone": "N/A",
    });
  }

  static Future leaveGroup(String userEmail, String groupPath, String userPath,
      String groupID) async {
    // how a user leaves a group

    final userDocRef =
        FirebaseFirestore.instance.collection(userPath).doc(groupID);
    final groupDocRef =
        FirebaseFirestore.instance.collection(groupPath).doc(userEmail);

    await userDocRef
        .delete(); // removes the group from the 'user' subcollection 'Groups'
    await groupDocRef
        .delete(); // removes the user from the 'Members' subcollection in 'groups'

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .update({"currentGroupID": FieldValue.delete()});
  }

  static Future createOrUpdate(GroupModel user) async {
    final docRef = FirebaseFirestore.instance.collection('groups').doc(user
        .groupID); // refrence of the specific document we want to put data into

    final newUser = GroupModel(
      bookName: user.bookName,
      groupBio: user.groupBio,
      groupName: user.groupName,
      groupID: user.groupID,
    ).toJson(); // converting data into Firestore type

    await docRef.set(newUser);
  }

  static Future subDelete(String path) async {
    final db = FirebaseFirestore.instance;

    await db
        .collection(path)
        .get()
        .then((snapshot) => // deletes all documents in Messages subcollection
            // ignore: avoid_function_literals_in_foreach_calls
            snapshot.docs.forEach((docuemnt) async {
              await docuemnt.reference.delete();
            }));
  }

  static Future clearUsers(String docPath, String userEmail) async {
    // this removes all users that are in the group

    final db = FirebaseFirestore.instance;

    final memberQuery = await db.collection('groups/$docPath/Members').get();

    for (final memberDoc in memberQuery.docs) {
      final memberEmail = memberDoc
          .id; // this represents the docID of a document in the nested subcollection Members

      final userGroupCollection = db.collection('users/$memberEmail/Groups');

      await userGroupCollection.doc(docPath).delete();
      final updates = <String, dynamic>{"currentGroupID": FieldValue.delete()};
      await db.collection('users').doc(userEmail).update(updates);
    }
  }

  static Future mainDelete(
      String docPath, String collectPath, String userEmail) async {
    GroupRepo.clearUsers(docPath, userEmail);

    await FirebaseFirestore.instance
        .collection('groups')
        .doc(docPath)
        .delete(); // removes the entire group document in firestore
  }
}

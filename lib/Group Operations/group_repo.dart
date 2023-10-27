import 'package:bookmates_app/Group%20Operations/group_model.dart';
import 'package:bookmates_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//this class manages all CRUD operations in firestore for the collection 'groups' as well as its subcollections 'Messages', 'Members' and 'Milestones'

// the docID of every group document will b the ID the user types in
// the id of every Member and Message document will be the email of the user who instantiates / updated it
// we use the 'async' and 'await' keywords because the code is contacting Firestore servers, the runtime is asyncronous with the compile time of our code

class GroupRepo {
  static Future<int> getMemberCount(String groupID) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .get();
    final data = snapshot.data();

    return data!['memberCount'];
  }

  static Future<String> getCurrentGroupID() async {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final userData =
        FirebaseFirestore.instance.collection('users').doc(userEmail);
    final snapshot = await userData.get();
    Map<String, dynamic>? data = snapshot.data();
    if (data != null && data.containsKey('currentGroupID')) {
      return data['currentGroupID'];
    } else {
      return "";
    }
  }

  static Future memAdd(String path, userEmail, groupID, int admin) async {
    //    CU / CRUD the 'Members' subcollection (nested in 'groups' collection)

    final db = FirebaseFirestore.instance;
    String currentGroupID = await getCurrentGroupID();

    await db.collection(path).doc(userEmail).set({
      "Member": userEmail,
      "isAdmin": admin == 1 ? true : false,
    });

    int newCount = await getMemberCount(groupID) + 1;

    await FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'memberCount': newCount,
    });
    //update the ratio of every milestone instantiated in a group, will get smaller
    //already have the new count, will get smaller

    // final allMilestones = await FirebaseFirestore.instance
    //     .collection('groups')
    //     .doc(currentGroupID)
    //     .collection('Milestone')
    //     .get();

    // //iterate through all documents in a groups Milestone sub to upd8 the ratio
    // if (allMilestones.docs.toList().isNotEmpty) {
    //   for (final milestoneDoc in allMilestones.docs) {
    //     final milestoneData = milestoneDoc.data();
    //     //get progression count in each doc
    //     final membersCompleted = milestoneData['progress'];
    //     //instantiate the new ratio in each doc
    //     final ratio = (membersCompleted / newCount) * 100;

    //     //input the new ratio in each milestone for the group
    //     await milestoneDoc.reference.set({
    //       'ratio': ratio,
    //     }, SetOptions(merge: true));
    //   }
    // }
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

    int newCount = await getMemberCount(groupID) - 1;
    await FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'memberCount': newCount,
    });

    //update the ratio for every milestone
    //update the ratio of every milestone instantiated in a group, will get larger

    // final allMilestones = await FirebaseFirestore.instance
    //     .collection('groups')
    //     .doc(groupID)
    //     .collection('Milestone')
    //     .get();

    // //iterate through all documents in a groups Milestone sub to upd8 the ratio
    // if (allMilestones.docs.toList().isNotEmpty) {
    //   for (final milestoneDoc in allMilestones.docs) {
    //     final milestoneData = milestoneDoc.data();
    //     //get progression count in each doc
    //     final membersCompleted = milestoneData['progress'];
    //     //instantiate the new ratio in each doc
    //     final ratio = (membersCompleted / newCount);

    //     //input the new ratio in each milestone for the group
    //     await milestoneDoc.reference.set({
    //       'ratio': ratio,
    //     }, SetOptions(merge: true));
    //   }
    // }
  }

  static Future createOrUpdate(GroupModel user) async {
    final docRef = FirebaseFirestore.instance.collection('groups').doc(user
        .groupID); // refrence of the specific document we want to put data into

    await docRef.set({
      'bookName': user.bookName,
      'groupBio': user.groupBio,
      'groupName': user.groupName,
      'groupID': user.groupID,
      'memberCount': 0,
    });
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

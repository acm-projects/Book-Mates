import 'dart:math';

import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// manages functionality all group operations in Firestore

Future<int> getMemberCount(String groupID) async {
  // return the current amount of members in a group
  final snapshot =
      await FirebaseFirestore.instance.collection('groups').doc(groupID).get();
  final data = snapshot.data();

  return data!['memberCount'];
}

String generateGroupID() {
  // creates a random 6-digit number that'll b the group's ID
  final random = Random();
  return (random.nextInt(900000) + 100000).toString();
}

Future<String> getCurrentGroupID() async {
  // return the group a user is currently in
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

Future<void> checkGroupExists(String userGroupInput, int leaveOrJoin) async {
  //if the groups the user types exists, then join or leave

  final userEmail = FirebaseAuth.instance.currentUser?.email;
  final groupCollection =
      await FirebaseFirestore.instance.collection('groups').get();

  for (final groupDoc in groupCollection.docs) {
    // checks if the id that the user inputted exists, if it does, then add that user
    final groupID = groupDoc.id;
    if (userGroupInput == groupID && leaveOrJoin == 1) {
      await addMember(
          'groups/$userGroupInput/Members', userEmail, userGroupInput, 0);
    }
    if (userGroupInput == groupID && leaveOrJoin == 0) {
      await loseMember(userEmail!, 'groups/$userGroupInput/Members', groupID);
    }
  }
}

Future addMember(String path, userEmail, groupID, int admin) async {
  bool validAdd = true; // assume they not in group

  final userGroups = await FirebaseFirestore.instance
      .collection('users/$userEmail/Groups')
      .get();

  final userGroupsDocs = userGroups.docs;

  for (final groupDoc in userGroupsDocs) {
    final userGroupID = groupDoc.id;
    if (userGroupID == groupID) validAdd = false; // if they are, stop operation
  }

  if (validAdd) {
    //add group to user's subcollection
    await joinGroup(userEmail, groupID);

    // update the member subcollection
    await FirebaseFirestore.instance.collection(path).doc(userEmail).set({
      "Member": userEmail,
      "isAdmin": admin == 1 ? true : false,
    });

    // get the new count and update the group data field
    int newCount = await getMemberCount(groupID) + 1;
    await FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'memberCount': newCount,
    });

    //update the ratio for every milestone
    await updateAllRatio(groupID, newCount);
  }
}

Future<void> loseMember(String userEmail, groupPath, groupID) async {
  // how a user leaves a group

  bool validLeave = false;
  // assume they aren't in the group, have to check in order to leave

  final userGroups = await FirebaseFirestore.instance
      .collection('users/$userEmail/Groups')
      .get();

  final userGroupsDocs = userGroups.docs;

  for (final groupDoc in userGroupsDocs) {
    final userGroupID = groupDoc.id;
    if (userGroupID == groupID) {
      validLeave = true; // if they are, change flag
    }
  }

  if (validLeave) {
    // delete group from user's subcollection
    await leaveGroup(userEmail, groupID);

    //delete user from 'Members' subcollection in a group
    final groupDocRef =
        FirebaseFirestore.instance.collection(groupPath).doc(userEmail);
    await groupDocRef.delete();

    // get the new member count and update the groups data field
    int newCount = await getMemberCount(groupID) - 1;
    await FirebaseFirestore.instance.collection('groups').doc(groupID).update({
      'memberCount': newCount,
    });

    // if there are no more memebers, just delete the group from existence
    if (newCount == 0) {
      await deleteGroup(groupID, userEmail);
      return;
    }

    //update the ratio for every milestone
    await updateAllRatio(groupID, newCount);
  }
}

Future createOrUpdate(
    String bookName, groupBio, groupName, userEmail, groupID) async {
  // create a group document and its data fields
  // create random groupID number
  final docRef = FirebaseFirestore.instance.collection('groups').doc(
      groupID); // refrence of the specific document we want to put data into

  await docRef.set({
    'bookName': bookName,
    'groupBio': groupBio,
    'groupName': groupName,
    'groupID': groupID,
    'memberCount': 0,
  });

  // add the user who created the group as a member
  await addMember('groups/$groupID/Members', userEmail, groupID, 1);
  // update the users subcollection upon joining
  await joinGroup(userEmail, groupID);
}

Future subDelete(String path) async {
  // to delete all documents in a collection
  final db = FirebaseFirestore.instance;

  await db
      .collection(path)
      .get()
      .then((snapshot) => snapshot.docs.forEach((docuemnt) async {
            await docuemnt.reference.delete();
          }));
}

Future clearUsers(String docPath, String userEmail) async {
  // removes a group from all users subcollection of groups, deletes their
  // current group aswell, just in case they have that group as their current one

  final db = FirebaseFirestore.instance;
  final memberQuery = await db.collection('groups/$docPath/Members').get();

  for (final memberDoc in memberQuery.docs) {
    final memberEmail = memberDoc.id;
    final userGroupCollection = db.collection('users/$memberEmail/Groups');
    await userGroupCollection.doc(docPath).delete();
    final updates = <String, dynamic>{"currentGroupID": FieldValue.delete()};
    await db.collection('users').doc(userEmail).update(updates);
  }
}

Future deleteGroup(String groupID, userEmail) async {
  // have to remove all users
  clearUsers(groupID, userEmail);
  // in Firestore, you have to delete all documents in a subcollection b4 u delete
  subDelete('groups/$groupID/Members');
  subDelete('groups/$groupID/Milestone');
  subDelete('groups/$groupID/Messages');
  // delete actual group
  await FirebaseFirestore.instance.collection('groups').doc(groupID).delete();
  // kick admin to homepage
}

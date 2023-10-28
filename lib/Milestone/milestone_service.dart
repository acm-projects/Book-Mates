import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getCurrentGroupID() async {
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

Future<void> createMilestone(String goal, int days) async {
  final timeLimit = DateTime.now().add(Duration(days: days));
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  Map<String, dynamic> milestone = {
    "id": id,
    "goal": goal,
    "startTime": DateTime.now(),
    "endTime": timeLimit,
    "progress": 0,
    "ratio": 0,
    "hide": false,
  };

  String currentGroupID = await getCurrentGroupID();
  final milestoneDB = FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Milestone');
  if (currentGroupID != "") {
    // Add milestone to current group
    milestoneDB.doc(id.toString()).set(milestone);
  } else {
    print('WARNING USER IS NOT IN A GROUP');
  }
}

Future<void> completeMilestone(String milestoneID) async {
  String currentGroupID = await getCurrentGroupID();
  final milestoneDB = FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Milestone')
      .doc(milestoneID);
  final snapshot = await milestoneDB.get();
  // Increment the progress
  int currentProgress = await snapshot.data()?['progress'];
  milestoneDB.set({'progress': currentProgress + 1}, SetOptions(merge: true));

  // get ratio
  final snapshotGroup = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .get();
  int members = snapshotGroup.data()?['memberCount'];
  double ratio = ((currentProgress + 1) / members) * 100;
  await milestoneDB.set({'ratio': ratio}, SetOptions(merge: true));

  // if ratio full set hide true to hide from milestone list
  if (ratio >= 100) {
    milestoneDB.set({"hide": true}, SetOptions(merge: true));
  }

  // add the completed milestone id to the user collection
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userEmail)
      .collection('completedMilestones')
      .doc()
      .set({'id': milestoneID});
}

Future<List<Map<String, dynamic>>> fetchMilestonesData() async {
  String currentGroupID = await getCurrentGroupID();
  String? userEmail = FirebaseAuth.instance.currentUser?.email;

  final userSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userEmail)
      .collection('completedMilestones')
      .get();
  final userMilestoneList = userSnapshot.docs.map((doc) => doc.data()).toList();

  final milestoneSnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Milestone')
      .get();
  final milestoneList =
      milestoneSnapshot.docs.map((doc) => doc.data()).toList();

  // remove all hidden milestones
  milestoneList.removeWhere((milestone) => milestone['hide'] == true);

  // remove all milestones that are the same as the user completed milestones
  if (userMilestoneList.isNotEmpty) {
    for (var userMilestone in userMilestoneList) {
      milestoneList
          .removeWhere((milestone) => milestone['id'] == userMilestone['id']);
    }
  }

  return milestoneList;
}

Future<bool> checkAdmin() async {
  String currentGroupID = await getCurrentGroupID();
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  final snapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Members')
      .doc(userEmail)
      .get();
  final data = snapshot.data();
  return data?['isAdmin'] as bool; // Check if null error
}

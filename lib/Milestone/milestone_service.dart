import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createMilestone(String goal, int days) async {
  // to create a milestone for a group
  final timeLimit = DateTime.now().add(Duration(days: days));
  String id = DateTime.now().millisecondsSinceEpoch.toString();

  //create an object of type milestone
  Map<String, dynamic> milestone = {
    "id": id,
    "goal": goal,
    "startTime": DateTime.now(),
    "endTime": timeLimit,
    "progress": 0,
    "ratio": 0,
  };

  // put the milstone in firestore
  String? currentGroupID = await getCurrentGroupID();
  final milestoneDB = FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Milestone');
  if (currentGroupID != "") {
    // Add milestone to current group
    milestoneDB.doc(id.toString()).set(milestone);
  }
}

Future<void> completeMilestone(String milestoneID) async {
  // to complete a milestone
  String? currentGroupID = await getCurrentGroupID();
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

  // if ratio full, set completeTime for notifcation to be sent out
  if (ratio >= 100) {
    await milestoneDB
        .set({'completeTime': DateTime.now()}, SetOptions(merge: true));
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
  // returning the single milestone, can only have one at a time

  String? currentGroupID = await getCurrentGroupID();

  final milestoneSnapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Milestone')
      .get();
  final milestoneList =
      milestoneSnapshot.docs.map((doc) => doc.data()).toList();

  return milestoneList;
}

Future<bool> checkAdmin() async {
  // optional functionality, can only admins make milestones?
  String? currentGroupID = await getCurrentGroupID();
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

Future<void> updateAllRatio(String groupID, int newCount) async {
  // to update all ratio's, helpful for when user leaves/joins group

  final milestoneRef = FirebaseFirestore.instance
      .collection('groups')
      .doc(groupID)
      .collection('Milestone');

  final snapshot = await milestoneRef.get();
  final milestoneCollection = snapshot.docs;

  for (var document in milestoneCollection) {
    final milestoneMap = document.data();
    final progress = milestoneMap['progress'];
    final ratio = (progress / newCount) * 100;

    await milestoneRef
        .doc(milestoneMap['id'])
        .set({'ratio': ratio}, SetOptions(merge: true));

    final map = await milestoneRef.doc(milestoneMap['id']).get();
    final maps = map.data();
    final ratios = maps!['ratio'];

    // delete the milestone when its completed
    if (ratios >= 100) {
      await milestoneRef.doc(milestoneMap['id']).delete();
    }
  }
}

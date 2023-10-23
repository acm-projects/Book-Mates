import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookmates_app/Milestone/milestone_model.dart';

class Milestone extends StatelessWidget {
  const Milestone({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MilestoneService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createMilestone(String groupId, MilestoneModel milestone) async {
    await _firestore.collection('groups').doc(groupId).collection('milestones').add(milestone.toJson());
  }

  Stream<List<MilestoneModel>> getMilestones(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('milestones').orderBy('creationDate', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => MilestoneModel.fromSnapshot(doc)).toList(),
    );
  }

  Future<void> isCompleted(String groupId, String milestoneId) async {
    await _firestore.collection('groups').doc(groupId).collection('milestones').doc(milestoneId).update({
      'isCompleted': true,
      'completionDate': Timestamp.now(),
    });
  }

  Future<double> updateMilestoneProgress(String milestoneId) async {
  // Get a reference to the Firestore instance and to the specific milestone document
  final firestore = FirebaseFirestore.instance;
  final milestoneRef = firestore.collection('milestones').doc(milestoneId);
  
  // Fetch the current values for totalMembers and completedMembers
  DocumentSnapshot snapshot = await milestoneRef.get();
  
  if (snapshot.exists && snapshot.data() != null) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    int currentTotalMembers = data['TotalMembers'] ?? 0;
    int currentCompletedMembers = data['CompletedCount'] ?? 0;

    //increment completedMembers count 
    int newCompletedMembers = currentCompletedMembers + 1;

    // Calculate the progress ratio (you can use this ratio elsewhere if needed)
    double progressRatio = newCompletedMembers / currentTotalMembers;
    await milestoneRef.update({'CompletedCount': newCompletedMembers});
    //update progress in firestore
    await milestoneRef.update({'ProgressRatio': progressRatio});

    // Return the new progress ratio
    return progressRatio;
  }

  throw Exception('Milestone does not exist');
}
}
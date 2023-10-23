import 'package:cloud_firestore/cloud_firestore.dart';

class MilestoneModel {
  final String milestoneName;
  final String milestoneId;
  final int totalMembers;
  final int completedMembers;

  MilestoneModel({required this.milestoneName, required this.milestoneId, required this.totalMembers, required this.completedMembers});

  factory MilestoneModel.fromSnapshot(DocumentSnapshot snap) {// returns a type GroupModel that got its data from Firestore
    var snapshot = snap.data() as Map<String, dynamic>;

    return MilestoneModel(
      milestoneName: snapshot['MilestoneName'] ?? '',
      milestoneId: snapshot['MilestoneId']?? '',
      totalMembers: snapshot ['TotalMembers'] ?? 0,
      completedMembers: snapshot ['CompletedCount'] ?? 0
    );
  }

  Map<String, dynamic> toJson() => {// turns object data in form firestore can understand
        "MilestoneName": milestoneName,
        "MilestoneId": milestoneId,
        "TotalMembers": totalMembers,
        "CompletedCount": completedMembers,
      };
    
    double get progress {
      if (totalMembers == 0){
        return 0;
      }
      return completedMembers/totalMembers;
    }
    
}
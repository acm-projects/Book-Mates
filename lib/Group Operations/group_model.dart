import 'package:cloud_firestore/cloud_firestore.dart';

// this is what each group will look like in Object form

class GroupModel {
  final String? bookName;
  final String? groupBio;
  final String? groupName;
  final String? groupID;

  GroupModel({this.bookName, this.groupBio, this.groupName, this.groupID});

  factory GroupModel.fromSnapshot(DocumentSnapshot snap) {// returns a type GroupModel that got its data from Firestore
    var snapshot = snap.data() as Map<String, dynamic>;

    return GroupModel(
      bookName: snapshot['BookName'],
      groupBio: snapshot['GroupBio'],
      groupName: snapshot["GroupName"],
      groupID: snapshot['GroupId'],
    );
  }

  Map<String, dynamic> toJson() => {// turns object data in form firestore can understand
        "BookName": bookName,
        "GroupBio": groupBio,
        "GroupName": groupName,
        "GroupId": groupID,
      };
}

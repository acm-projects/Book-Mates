import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String? bookName;
  final String? groupBio;
  final String? groupName;
  final String? groupID;

  GroupModel({this.bookName, this.groupBio, this.groupName, this.groupID});

  factory GroupModel.fromSnapshot(DocumentSnapshot snap) {
    // when fetching data from firestore, this turns that map into object form
    var snapshot = snap.data() as Map<String, dynamic>;

    return GroupModel(
      bookName: snapshot['BookName'],
      groupBio: snapshot['GroupBio'],
      groupName: snapshot["GroupName"],
      groupID: snapshot['GroupId'],
    );
  }

  Map<String, dynamic> toJson() => {
        // turns object data in form firestore can understand
        "BookName": bookName,
        "GroupBio": groupBio,
        "GroupName": groupName,
        "GroupId": groupID,
      };
}

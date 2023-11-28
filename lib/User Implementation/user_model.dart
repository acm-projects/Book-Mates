import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  // User identity properties
  final String? id;
  final String? username;
  final String? email;
  final String password;

  // Agora video call properties
  int? agoraUid;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  Widget? videoView;

  UserModel({
    this.username,
    this.email,
    required this.id,
    required this.password,
    this.agoraUid,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.videoView,
  });

  // Factory method to create a UserModel from Firestore snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['Email'],
      id: snapshot['id'],
      password: snapshot["Password"],
      username: snapshot['userName'],
      // Initialize Agora properties if they exist in the snapshot
      agoraUid: snapshot['agoraUid'],
      isAudioEnabled: snapshot['isAudioEnabled'],
      isVideoEnabled: snapshot['isVideoEnabled'],
      // videoView is typically not stored in Firestore, so it's not included here
    );
  }

  // Convert UserModel to JSON for Firestore
  Map<String, dynamic> toJson() => {
        "userName": username,
        "Password": password,
        "id": id,
        "Email": email,
        // Include Agora properties
        "agoraUid": agoraUid,
        "isAudioEnabled": isAudioEnabled,
        "isVideoEnabled": isVideoEnabled,
        // videoView is typically not included as it's a UI widget
      };

  // Retrieve the userName of the current user
  Future<String?> getUserName() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return userSnapshot.data()!['userName'];
  }
}

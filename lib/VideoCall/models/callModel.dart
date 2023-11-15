import 'package:cloud_firestore/cloud_firestore.dart';

class Call {
  String callId;
  String groupId;
  List<String> participants; // List of user IDs
  String status; // e.g., 'initiated', 'in progress', 'ended'
  DateTime timestamp; // Time when the call was started

  Call({
    required this.callId,
    required this.groupId,
    required this.participants,
    required this.status,
    required this.timestamp,
  });

  // Converting a Call object into a Map
  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'groupId': groupId,
      'participants': participants,
      'status': status,
      'timestamp': timestamp,
    };
  }

  // Creating a Call object from a Firestore document
  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callId: map['callId'],
      groupId: map['groupId'],
      participants: List<String>.from(map['participants']),
      status: map['status'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}

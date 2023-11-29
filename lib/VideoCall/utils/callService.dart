import 'package:cloud_firestore/cloud_firestore.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to the 'calls' subcollection of a specific group
  CollectionReference getCallCollectionRef(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('calls');
  }

  // Adds a participant to a call
  Future<void> addParticipantToCall(
      String groupId, String callId, String userId) async {
    DocumentReference callDocRef = getCallCollectionRef(groupId).doc(callId);

    // Atomically add a new participant to the 'participants' array
    return await callDocRef.update({
      'participants': FieldValue.arrayUnion([userId]),
    });
  }

  // Removes a participant from a call
  Future<void> removeParticipantFromCall(
      String groupId, String callId, String userId) async {
    DocumentReference callDocRef = getCallCollectionRef(groupId).doc(callId);

    // Atomically remove a participant from the 'participants' array
    return await callDocRef.update({
      'participants': FieldValue.arrayRemove([userId]),
    });
  }

  // Listens for changes in the call participants
  Stream<DocumentSnapshot> onCallUpdated(String groupId, String callId) {
    DocumentReference callDocRef = getCallCollectionRef(groupId).doc(callId);
    return callDocRef.snapshots();
  }
}
import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

Future<void> deleteMessage(
    String senderId, groupId, messageId, String? mediaUrl) async {
  if (senderId == (FirebaseAuth.instance.currentUser?.uid)) {
    //make sure user is sender of message
    try {
      //if the message contains media, delete it from firebase storage
      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        Reference storageReference =
            FirebaseStorage.instance.refFromURL(mediaUrl);
        await storageReference.delete();
      }

      //delete message using firebase' delete function
      CollectionReference groupChat =
          FirebaseFirestore.instance.collection('groups/$groupId/Messages');

      await groupChat.doc(messageId).delete();
    } catch (e) {
      print("Cannot delete message: $e");
    }
  } else {
    //error message if user not authenticated as sender
    print("Only the sender can delete the message");
  }
}

Future<List<DocumentSnapshot>> displayMessages({int limit = 30}) async {
  CollectionReference groupChat = FirebaseFirestore.instance
      .collection('groups/${await getCurrentGroupID()}/Messages');

  QuerySnapshot snapshot = await groupChat
      .orderBy('timeStamp', descending: false)
      .limit(limit)
      .get();

  return snapshot.docs;
}

Future<DocumentReference> sendMessage(String text, String type) async {
  CollectionReference groupChat = FirebaseFirestore.instance
      .collection('groups/${await getCurrentGroupID()}/Messages');

  return groupChat.add({
    // add data fields in firestore
    'text': text,
    'senderID': FirebaseAuth.instance.currentUser?.email,
    'timeStamp': FieldValue.serverTimestamp(),
    'type': type,
    'mediaURL': '', //for images, videos, gifs, etc
  });
}

Future<void> sendMedia(String mediaUrl) async {
  try {
    String? currentGroupID = await getCurrentGroupID();
    final groupDB = FirebaseFirestore.instance
        .collection('groups')
        .doc(currentGroupID)
        .collection('Messages');
    await groupDB.add({
      'text': 'none',
      'senderID': FirebaseAuth.instance.currentUser?.email,
      'timeStamp': FieldValue.serverTimestamp(),
      'type': 'media',
      'mediaURL': mediaUrl,
    });
  } catch (e) {
    print('Error $e');
    return;
  }
}

//updates readby array with the current user who has read it
Future<void> readMessage(String messageId) async {
  DocumentReference groupChat = FirebaseFirestore.instance
      .collection('groups/${await getCurrentGroupID()}/Messages')
      .doc(messageId);

  return groupChat.update({
    'readBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.email])
  });
}

Future<void> uploadMedia(File mediaFile) async {
  String? currentGroupID = await getCurrentGroupID();
  // need to get the file extension type 'pdf, jpg, etc'
  String fileExtension = mediaFile.path.split('.').last;
  String filePath =
      'groups/$currentGroupID/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

  Reference storageReference = FirebaseStorage.instance.ref().child(filePath);
  UploadTask uploadTask = storageReference.putFile(mediaFile);

  //wait for upload to finish to download url
  await uploadTask.whenComplete(() async {
    String downloadUrl = await storageReference.getDownloadURL();
    print('URL $downloadUrl');
    sendMedia(downloadUrl);
  });
}

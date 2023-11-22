import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

Future<DocumentReference> sendMessage(String text) async {
  CollectionReference groupChat = FirebaseFirestore.instance
      .collection('groups/${await getCurrentGroupID()}/Messages');

  return groupChat.add({
    // add data fields in firestore
    'text': text,
    'senderID': FirebaseAuth.instance.currentUser?.email,
    'timeStamp': FieldValue.serverTimestamp(),
    'type': 'text',
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

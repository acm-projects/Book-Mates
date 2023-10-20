import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

String? email = FirebaseAuth.instance.currentUser?.email;

Future<String> getGroupId() async{
    String? email = FirebaseAuth.instance.currentUser?.email;
    final userdb = FirebaseFirestore.instance.collection('users').doc(email);
    final snapshot = await userdb.get();
    Map<String, dynamic>? data = snapshot.data()!;
    return data['currentGroupID'];
}

Future<void> deleteMessage(String senderId, String groupId, String messageId, String? mediaUrl) async {
  //make sure user is sender of message
  if(senderId == (FirebaseAuth.instance.currentUser?.uid)) {
     try {
        //if the message contains media, delete it from firebase storage
        if (mediaUrl != null && mediaUrl.isNotEmpty) {
          Reference storageReference = FirebaseStorage.instance.refFromURL(mediaUrl);
          await storageReference.delete();
        }

        //delete message using firebase' delete function
        CollectionReference groupChat = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('GroupChat');
        await groupChat.doc(messageId).delete();
     } catch (e) {
        print("Cannot delete message: $e");
     }
  } else {
    //error message if user not authenticated as sender
     print("Only the sender can delete the message");
  }
}

Future<List<DocumentSnapshot>> displayMessages(String groupId, {int limit = 10}) async {
  CollectionReference groupChat = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('GroupChat');
  
  QuerySnapshot snapshot = await groupChat
      .orderBy('timeStamp', descending: true)
      .limit(limit)
      .get();

  return snapshot.docs;
}

Future<DocumentReference> sendMessage(String groupId, String text, String type) async {
  CollectionReference groupChat = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('GroupChat');
  
  return groupChat.add({
    'text': text,
    'senderID': FirebaseAuth.instance.currentUser?.email,
    'timeStamp': FieldValue.serverTimestamp(),
    'type': type,
    'readBy': [FirebaseAuth.instance.currentUser?.email], //array that indicates users in the gc that have read message, originally only the sender
    'mediaURL': '', //for images, videos, gifs, etc
  });
}

//updates readby array with the current user who has read it
Future<void> readMessage(String groupId, String messageId) async{
    DocumentReference groupChat = FirebaseFirestore.instance.collection('groups').doc(groupId).collection('GroupChat').doc(messageId);

    return groupChat.update({
        'readBy': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.email])
    });
}

Future<String?> uploadMedia(File mediaFile, String groupId) async {
  try {
    //it can be diff file extensions so we have to extract the file extension from the upload
    String fileExtension = mediaFile.path.split('.').last;

    //get filepath to inlclude in storage
    String filePath = 'groupChat/$groupId/${DateTime.now().millisecondsSinceEpoch}.$fileExtension'; 

    //initiate firebase storage where we will store the file
    Reference storageReference = FirebaseStorage.instance.ref().child(filePath);

    //upload file and store it on firebase
    UploadTask uploadTask = storageReference.putFile(mediaFile);

    //wait for upload to finish to download url
    await uploadTask.whenComplete(() => {});
    String downloadUrl = await storageReference.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print("Error uploading media: $e");
    return null;
  }
}
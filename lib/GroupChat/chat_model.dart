import 'package:cloud_firestore/cloud_firestore.dart';

//this model is the main data structure for an instance of a chat message
class ChatMessage {
  final String? senderId;
  final String? text;
  final Timestamp? timeStamp;
  final String? type;
  final List<String>? readBy;
  final String? mediaURL;
  final String? messageId;

  ChatMessage(
      {this.senderId,
      this.text,
      this.timeStamp,
      this.type,
      this.readBy,
      this.mediaURL,
      this.messageId});

  factory ChatMessage.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatMessage(
      senderId: snapshot['senderID'],
      text: snapshot['text'],
      timeStamp: snapshot['timeStamp'] as Timestamp,
      type: snapshot["type"],
      readBy: List<String>.from(snapshot['readBy']),
      mediaURL: snapshot['mediaURL'],
      messageId: snap.id,
    );
  }
  //make sure firebase can understand data
  Map<String, dynamic> toJson() => {
        "senderId": senderId,
        "text": text,
        "timeStamp": timeStamp,
        "type": type,
        "readBy": readBy,
        "mediaURL": mediaURL,
      };
}

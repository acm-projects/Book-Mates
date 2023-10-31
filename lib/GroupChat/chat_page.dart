import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_service.dart';
import 'chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:bookmates_app/Group Operations/group_repo.dart';

class ChatHome extends StatefulWidget {
  //use Key class to order stream and update efficiently
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

// Example function to show delete functionality - can be expanded upon
void deleteMessageFunctionality(BuildContext context, ChatMessage message) {
  // Implement the functionality to delete the message.
  // This can involve showing a dialog to confirm the deletion, then calling deleteMessage.
}

class _ChatHomeState extends State<ChatHome> {
  final _messageController = TextEditingController();

  Widget _entryField() {
    // the entry field where user inputs text and or media
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: "Message..."),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_messageController.text.isNotEmpty) {
                await sendMessage(_messageController.text, 'text');
                _messageController.clear();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              FilePickerResult? mediaUp =
                  await FilePicker.platform.pickFiles(type: FileType.media);
              if (mediaUp != null && mediaUp.files.isNotEmpty) {
                File selectedFile = File(mediaUp.files.single.path!);
                await uploadMedia(selectedFile);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget getImage(QueryDocumentSnapshot<Object?> o, bool isUser) {
    // checking wether a text or an image was sent
    if (o['mediaURL'] != '') {
      return Image.network(
        o['mediaURL'],
        width: 200,
        height: 200,
      );
    } else {
      return Text(
        o['text'],
        style: TextStyle(color: isUser ? Colors.blue : Colors.grey),
      );
    }
  }

  Widget _messageList(String? text) {
    // listing all messages in the cloud
    return SizedBox(
      height: MediaQuery.of(context).size.height - 202.0,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('groups')
            .doc(text)
            .collection('Messages')
            .orderBy('timeStamp')
            .snapshots(),
        builder: (buildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              //changing the alingment id you were the one to send the message
              bool isUser = (document['senderID'] ==
                  FirebaseAuth.instance.currentUser?.email);
              Alignment alignment =
                  isUser ? Alignment.centerRight : Alignment.centerLeft;
              return Column(
                children: [
                  Align(
                    alignment: alignment, // Apply the alignment here
                    child: SizedBox(
                      child: getImage(document, isUser),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: const Text('Messaging'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: getCurrentGroupID(),
                  initialData: 'Loading messages...',
                  builder: (BuildContext context, AsyncSnapshot<String> text) {
                    return _messageList(text.data);
                  }),
              _entryField(),
            ],
          ),
        ),
      ),
    );
  }
}

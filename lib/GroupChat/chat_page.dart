import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
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
            // icon user presses to send a message
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_messageController.text.isNotEmpty) {
                await sendMessage(_messageController.text, 'text');
                _messageController.clear();
              }
            },
          ),
          IconButton(
            // button that lets you choose an img to upload
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
    // listing all messages/images in the cloud
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
                      // output will either be a text msg or img based on
                      // the existence of the 'mediaUrl' data field
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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF75A10F), // Background color
            height: double.infinity,
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173), // Tan color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Replace this section with your FutureBuilder
                    FutureBuilder(
                      future: getCurrentGroupID(),
                      initialData: 'Loading messages...',
                      builder: (context, text) {
                        return _messageList(text.data);
                      },
                    ),
                    // where user inputs text or an img
                    _entryField(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text(
                'Messaging',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'LeagueSpartan',
                  fontWeight: FontWeight.w600,
                  color: Colors.white, // Text color
                  shadows: [
                    BoxShadow(
                      color: Color.fromRGBO(70, 70, 70, 0.918),
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

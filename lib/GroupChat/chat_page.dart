import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat_service.dart';
import 'chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
                String? media = await uploadMedia(selectedFile);
              }
            },
          ),
        ],
      ),
    );
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: alignment, // Apply the alignment here
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 25,
                      // ignore: prefer_interpolation_to_compose_strings
                      child: Text(
                        document['text'],
                        style: TextStyle(
                          // Optionally, you can style the text based on the alignment
                          color: isUser ? Colors.blue : Colors.grey,
                        ),
                      ),
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

  /*

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
              //putting streambuilder before buttons
              FutureBuilder(
                  future: getGroupId(),
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
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.lightGreen, // Background color
            height: double.infinity,
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
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
                      future: getGroupId(),
                      initialData: 'Loading messages...',
                      builder:
                          (BuildContext context, AsyncSnapshot<String> text) {
                        return _messageList(text.data);
                      },
                    ),
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
              title: Text(
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

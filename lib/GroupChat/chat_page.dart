// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:bookmates_app/Group%20Operations/group_home.dart';
import 'package:bookmates_app/Group%20Operations/group_repo.dart';
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
  // holding user message input
  final _messageController = TextEditingController();
  // users email
  final email = FirebaseAuth.instance.currentUser?.email;
  // for scrolling
  final ScrollController _scrollController = ScrollController();

  // where user inputs message or sends an image
  Widget _entryField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAF1D5), // Changed color of the bottom app bar
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: <Widget>[
            // where you choose to send an image
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () async {
                FilePickerResult? mediaUp =
                    await FilePicker.platform.pickFiles(type: FileType.media);
                if (mediaUp != null && mediaUp.files.isNotEmpty) {
                  File selectedFile = File(mediaUp.files.single.path!);
                  // upload the file you chose to FirebaseStoreage and Firestore
                  await uploadMedia(selectedFile);
                }
              },
            ),
            // where user types in thier message
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Type a message here",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                style: const TextStyle(fontFamily: 'LeagueSpartan'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              // to send a message in firestore
              onPressed: () async {
                await sendMessage(_messageController.text);
                // clear the entryField
                _messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }

  // the individual chat message
  Widget _chatBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? const Color.fromARGB(255, 255, 241, 199)
              : const Color.fromARGB(255, 7, 7, 7),
          borderRadius: isUser
              ? const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                )
              : const BorderRadius.only(
                  bottomRight: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.black87 : Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  // listing all messages/images in the cloud
  Widget _messageList(String? text) {
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
          return Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              controller: _scrollController,
              children: snapshot.data!.docs.map((document) {
                // flag determinng if you were the one to send the message or not
                bool isUser = (document['senderID'] == email);
                Widget messageType = (document['mediaURL'] == '')
                    ? _chatBubble(document['text'], isUser)
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0),
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Image.network(document['mediaURL']),
                        ),
                      );
                return messageType;
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _title() {
    return FutureBuilder(
      future: getGroupData(),
      builder: (context, groupData) {
        if (groupData.hasData) {
          return Row(children: [
            InkWell(
              onTap: () async {
                await uploadGroupProfPic();
                // referesh UI
                setState(() {});
              },
              // the profile pic of the group
              child: SizedBox(
                width: 70,
                height: 70,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(groupData.data!['profPicURL']),
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            // the title, the name of the group
            Text(
              groupData.data!['groupName'],
              style: const TextStyle(
                fontFamily: 'LeagueSpartan',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ]);
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: const Color(0xFFFAF1D5),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
      ),
      backgroundColor: const Color(0xFF75A10F),
      body: Column(
        children: <Widget>[
          const SizedBox(
              height: 10), // Adds space between the AppBar and messages
          Expanded(
              child: FutureBuilder(
                  future: getCurrentGroupID(),
                  builder: (context, groupID) {
                    if (groupID.hasData)
                      return _messageList(groupID.data);
                    else
                      return Container();
                  })),
          _entryField(),
        ],
      ),
    );
  }
}

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
class _ChatHomeState extends State<ChatHome> {
  final TextEditingController _messageController = TextEditingController();
  final String _groupId = "dummyGroupId";  // replace with an actual groupId for testing
  final String _type = "text";  // assuming text for simplicity
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Home'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: displayMessages(_groupId),
              builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text("Error loading messages"));
                }

                List <ChatMessage> messages = snapshot.data!.map((doc) => ChatMessage.fromSnapshot(doc)).toList();
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index].text ?? ""),
                      subtitle: Text("Sent by: ${messages[index].senderId}"),
                      // Potential spots for features:
                      onTap: () => readMessage(_groupId, messages[index].messageId!),
                      onLongPress: () => deleteMessageFunctionality(context, messages[index])
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Message..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      await sendMessage(_groupId, _messageController.text, _type);
                      _messageController.clear();
                      setState(() {});  // Refresh UI
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: () async {
                    FilePickerResult? mediaUp = await FilePicker.platform.pickFiles(type: FileType.media);
                    if (mediaUp != null && mediaUp.files.isNotEmpty) {
                      File selectedFile = File(mediaUp.files.single.path!);
                      String? media = await uploadMedia(selectedFile, _groupId);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Example function to show delete functionality - can be expanded upon
  void deleteMessageFunctionality(BuildContext context, ChatMessage message) {
    // Implement the functionality to delete the message.
    // This can involve showing a dialog to confirm the deletion, then calling deleteMessage.
  }
}


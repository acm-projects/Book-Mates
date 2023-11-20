import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat UI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyText2: TextStyle(fontFamily: 'LeagueSpartan'),
        ),
      ),
      home: ChatMainPage(),
    );
  }
}

class ChatMainPage extends StatefulWidget {
  @override
  _ChatMainPageState createState() => _ChatMainPageState();
}

class _ChatMainPageState extends State<ChatMainPage> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Group',
          style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color(0xFFFAF1D5),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
      ),
      backgroundColor: Color(0xFF75A10F),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10), // Adds space between the AppBar and messages
          Expanded(
            child: _messageList(),
          ),
          _entryField(),
        ],
      ),
    );
  }

  Widget _entryField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFAF1D5), // Changed color of the bottom app bar
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () async {
                FilePickerResult? mediaUp =
                    await FilePicker.platform.pickFiles(type: FileType.media);
                if (mediaUp != null && mediaUp.files.isNotEmpty) {
                  File selectedFile = File(mediaUp.files.single.path!);
                  // Add your logic to handle file upload
                }
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Type a message here",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
                style: TextStyle(fontFamily: 'LeagueSpartan'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                // Placeholder for send message logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageList() {
    // Adjust the alignment of the messages to the bottom
    return Align(
      alignment: Alignment.bottomCenter,
      child: ListView.builder(
        controller: _scrollController,
        padding:
            EdgeInsets.only(top: 10), // Additional space at the top of the list
        itemCount: 2, // Replace with your dynamic message count
        itemBuilder: (context, index) {
          bool isUser = index % 2 == 0;
          String message = isUser
              ? 'Hello, how are you?'
              : 'I am fine, thanks! How about you?';
          return _chatBubble(message, isUser);
        },
      ),
    );
  }

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
              ? Color.fromARGB(255, 255, 241, 199)
              : Color.fromARGB(255, 7, 7, 7),
          borderRadius: isUser
              ? BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                )
              : BorderRadius.only(
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
}

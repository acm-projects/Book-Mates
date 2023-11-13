import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHomeScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildMainContent(),
          _buildAppBar(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      color: Colors.lightGreen,
      height: double.infinity,
    );
  }

  Widget _buildMainContent() {
    return Positioned(
      top: 100,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 223, 173),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(35.0),
            topRight: const Radius.circular(35.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildMessageList(),
              _buildEntryField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 202.0,
      child: ListView(
        children: [
          // Placeholder for your messages UI, you can add messages here based on your design
        ],
      ),
    );
  }

  Widget _buildEntryField() {
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
            onPressed: () {
              // Handle send button click
              if (_messageController.text.isNotEmpty) {
                // Add your logic to handle sending messages
                _messageController.clear();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              // Handle file upload button click
              FilePickerResult? mediaUp =
                  await FilePicker.platform.pickFiles(type: FileType.media);
              if (mediaUp != null && mediaUp.files.isNotEmpty) {
                File selectedFile = File(mediaUp.files.single.path!);
                // Add your logic to handle file upload
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
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
            color: Colors.white,
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
    );
  }
}

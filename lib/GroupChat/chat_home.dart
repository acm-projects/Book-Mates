
import 'package:bookmates_app/Group Operations/join_group.dart';
import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  final _controllerMessage = TextEditingController();

  Future<String> getCurrentGroup() async { // returns the current group that the users in as a String
    String? userEmail = auth.currentUser?.email;
    final userDB = db.collection('users').doc(userEmail);
    final snapshot = await userDB.get();

    Map<String, dynamic>? data = snapshot.data();
    return data!['currentGroupID'].toString();
  }

  Future<void> sendMessage(String messageContent) async { // to send message to the cloud

    String? userEmail = auth.currentUser?.email;
    String currentGroup = await getCurrentGroup();

    await GroupRepo.msgAdd('groups/$currentGroup/Messages', userEmail, messageContent);

  }
 

// *************************Widgets that make up the page****************************
 
  Widget _entryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: _controllerMessage,
          decoration: const InputDecoration(hintText: 'type...'),
        ),
        ElevatedButton(
          onPressed: () {
            sendMessage(_controllerMessage.text);
            _controllerMessage.clear();
          },
          child: const Text('Send'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Group Name'),
        ),
        body: Column(
          children: [
            //putting streambuilder before buttons
            FutureBuilder(
                future: getCurrentGroup(),
                initialData: 'Loading messages...',
                builder: (BuildContext context, AsyncSnapshot<String> text) {
                  return _messageList(text.data);
                }),
            _entryField(),
          ],
        ),
      ),
    );
  }

  Widget _messageList(String? text) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 201.0,
      child: StreamBuilder(
        stream: db
            .collection('groups')
            .doc(text)
            .collection('Messages')
            .orderBy('TimeCreated')
            .snapshots(),
        builder: (buildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              bool isUser = (document['senderID'] == userEmail);

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
                        document['messageContent'],
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
}

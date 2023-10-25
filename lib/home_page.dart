import 'dart:io';
import 'PDF Upload/pdf_screen.dart';
import 'package:bookmates_app/Group Operations/create_group.dart';
import 'package:bookmates_app/Group Operations/join_group.dart';
import 'package:bookmates_app/GroupChat/chat_page.dart';
import 'package:bookmates_app/api_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bookmates_app/auth.dart';

// the page you see when you sign in
final user = Auth()
    .currentUser; // the user is the data of the user thats currently signed in

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Widget _betterButton(BuildContext c, Widget w, String buttonLabel) {
  return ElevatedButton(
    onPressed: () {
      Navigator.of(c).push(
        MaterialPageRoute(
          builder: (context) => w,
        ),
      );
    },
    child: Text(buttonLabel),
  );
}

Widget _signOut(BuildContext c) {
  return ElevatedButton(
    onPressed: () {
      // Stop background service if user is not logged in
      // FlutterBackgroundService().invoke('stopService');
      print('BACKGROUND:::::::::::::SERVICE:::::::::::::STOPPED');
      // RecentlyRead.clearHistory(); // clear the history of book reading
      Auth().signOut();
      sleep(const Duration(milliseconds: 200));
      // Restart.restartApp()
    },
    child: const Text('Sign Out'),
  );
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _betterButton(context, const JoinGroup(), 'Join Group'),
              _betterButton(
                  context, const CreateOrDeleteGroup(), 'Create/Delete Group'),
              _betterButton(context, const ChatHome(), 'Messaging'),
              _betterButton(context, const APIPage(), 'api-stuff'),
              _betterButton(context, const PDFReaderApp(), 'pdf-stuff'),
              _signOut(context),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore
              .instance // everytime this updates, re render whatevers under this // FirebaseFirestore.instance.collection('users').where("Email", isEqualTo: user?.email).snapshots(), only return the user thats signed in
              .collection('users')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              //if the data has not loaded, show the common loading screen
              return const CircularProgressIndicator();
            }
            return ListView(
              children: snapshot.data!.docs.map((document) {
                // the children of this ListView is each individual document
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 25,
                        child: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            "${"Email: " + document["Email"]}  Password: " +
                                document['Password']),
                      ),
                    ]);
              }).toList(),
            );
          }),
    );
  }
}

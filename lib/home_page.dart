import 'dart:io';
import 'package:bookmates_app/API/screens/book_search_screen.dart';
import 'package:bookmates_app/Group%20Operations/group_home.dart';
import 'package:bookmates_app/Group%20Operations/group_list.dart';
import 'package:bookmates_app/Milestone/milestone_page.dart';
import 'package:bookmates_app/demo_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'PDF Upload/pdf_screen.dart';
import 'package:bookmates_app/Group Operations/create_group.dart';
import 'package:bookmates_app/Group Operations/join_group.dart';
import 'package:bookmates_app/GroupChat/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// the page you see when you sign in

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Widget _betterButton(BuildContext c, Widget w, String buttonLabel) {
  //button that navigates you to other sevices offered by the app
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
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
      sleep(const Duration(milliseconds: 200));
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
              _betterButton(context, const GroupHome(), 'Group Home Page'),
              _betterButton(context, const Groups(), 'Group list'),
              _betterButton(context, const JoinGroup(), 'Join Group'),
              _betterButton(context, const CreateGroupScreen(), 'Create/Delete Group'),
              _betterButton(context, const ChatHome(), 'Messaging'),
              _betterButton(context, const PDFReaderApp(), 'pdf-stuff'),
              _betterButton(context, const MilestoneListPage(), 'Milestones'),
              _betterButton(context, BookSearchScreen(), 'Api-stuff'),
              _signOut(context),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const DemoPage();
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














/*import 'package:bookmates_app/Group%20Operations/create_group.dart';
import 'package:bookmates_app/Group%20Operations/join_group.dart';
import 'package:bookmates_app/GroupChat/chat_home.dart';
import 'package:bookmates_app/Milestone/milestone_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookmates_app/GroupChat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:bookmates_app/auth.dart';

// the page you see when you sign in
final user = Auth().currentUser; // the user is the data of the user thats currently signed in

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
      Auth().signOut();
    },
    child: const Text('Sign Out'),
  );
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _betterButton(context, const JoinGroup(), 'Join Group'),
              _betterButton(context, const CreateOrDeleteGroup(),'Create/Delete Group'),
              _betterButton(context, const ChatHome(), 'Group Chat'),
              _betterButton(context, MilestoneTester(), 'Milestones'),
              _signOut(context),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore
              .instance // everytime this updates, re render whatevers under this // FirebaseFirestore.instance.collection('users').where("Email", isEqualTo: user?.email).snapshots(), only return the user thats signed in
              .collection('groups/$getGroupId()/Messages')
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
                        width: MediaQuery.of(context).size.width ,
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
}*/

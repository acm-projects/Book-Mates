import 'package:bookmates_app/Group%20Operations/create_group.dart';
import 'package:bookmates_app/Group%20Operations/join_group.dart';
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

// ignore: unused_element
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
              _betterButton(context, const CreateOrDeleteGroup(),
                  'Create/Delete Group'), // have to change the group chats location
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
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.height / 6,
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

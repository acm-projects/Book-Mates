import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/demo_page.dart';
import 'package:bookmates_app/library.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  // to dynamically render every group a user's in
  Widget _listGroups() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users/$userEmail/Groups')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Widget> groupCards = [];
          // make it where is shows two groups per row
          for (int i = 0; i < snapshot.data!.docs.length; i += 2) {
            final groupDocData1 = snapshot.data!.docs[i];
            final groupName1 = groupDocData1['groupName'];
            final groupID1 = groupDocData1['groupID'];

            // assigning the 2 cards to the groups the users in
            Widget card1 = _groupCard(groupName1, groupID1);
            Widget card2 = Container();
            if (i + 1 < snapshot.data!.docs.length) {
              final groupDocData2 = snapshot.data!.docs[i + 1];
              final groupName2 = groupDocData2['groupName'];
              final groupID2 = groupDocData2['groupID'];
              card2 = _groupCard(groupName2, groupID2);
            }

            // now this widget has 2 cards in the flex layout 'Row'
            groupCards.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [card1, card2].where((card) => card != null).toList(),
            ));
          }

          return Column(
            children: groupCards,
          );
        } else {
          return const DemoPage();
        }
      },
    );
  }

  // the card representing a group a users in
  Widget _groupCard(String groupName, groupID) {
    return GestureDetector(
      // when a user presses a button, change their currentgroup and navigate to group home page
      onTap: () async {
        // change the users currentGroup to the card they've pressed
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .set({
          'currentGroupID': groupID,
        }, SetOptions(merge: true));
        // navigate them to the group Home page
        Navigator.of(context).pushNamed('/groupWidgetTree');
      },
      onLongPress: () {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Leave Group'),
                content: const Text('Are you sure you want to leave?'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await loseMember(
                            userEmail!, 'groups/$groupID/Members', groupID);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              );
            });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 10), // Adjust vertical padding as needed
        child: Row(
          children: [
            const SizedBox(width: 20),
            Container(
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(25),
                color: const Color.fromARGB(255, 205, 201, 201),
                border: Border.all(width: 2),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    groupName,
                    style: const TextStyle(fontFamily: 'Spartan', fontSize: 20),
                  ),
                  Container(
                    height: 100,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 145, 179, 206),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // button user presses create a group
  Widget _createGroupButton() {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed('/createGroup'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF75A10F),
      ),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  // the 'main' of flutter, where are widgets shown are actually put on the screen
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 241, 213),
          title: const Text('Your Groups',
              style: TextStyle(color: Colors.black87, fontFamily: 'Spartan')),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // widgets
          children: [
            MySearchBarWidget(),
            Expanded(child: _listGroups()),
            _createGroupButton()
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 117, 161, 15),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}

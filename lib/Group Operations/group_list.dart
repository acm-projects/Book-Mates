import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/demo_page.dart';
import 'package:bookmates_app/library.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:scaled_list/scaled_list.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    setState(() {});
  }

  Future<String?> getProfURL(String groupID) async {
    final groupRef = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .get();
    return groupRef.data()!['profPicURL'];
  }

 final List<Color> kMixedColors = [
  const Color.fromARGB(255, 250, 241, 213)
  ];

  // to dynamically render every group a user's in
  Widget _listGroups() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users/$userEmail/Groups')
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // make a list of cards of the groups that a user is in
          List<Map<String, dynamic>> carouselItems = snapshot.data!.docs.map((document) {
            // make object view of each group a user is in
            Map<String, dynamic> groupData =
                document.data() as Map<String, dynamic>;
                return groupData;
          }).toList();

          // with those cards, make a carousel
          return ScaledList(
            selectedCardHeightRatio: 1,
            unSelectedCardHeightRatio: 0.4,
            // unSelectedCardHeightRatio: 0.35,
            marginWidthRatio: 0.1,
            cardWidthRatio: 0.7,
          itemCount: carouselItems.length,
          itemColor: (index) {
                  return kMixedColors[0];
                },
          itemBuilder: (index, selectedIndex) {
            final carousel = carouselItems[index];

            return FutureBuilder(
                future: getProfURL(carousel['groupID']),
                builder: (context, urlSnapShot) {
                  if (urlSnapShot.hasData) {
                    return _groupCard(carousel["groupName"], carousel["groupID"], urlSnapShot.data, selectedIndex == index || (carouselItems.length == 1 && index == 0));
                  }
                  else {
                    return Container();
                  }
                },
            );
          },
          // scaleExtent: 0.8, // Adjust the scale extent as needed
          // horizontalScrollBar: true, // Enable horizontal scrollbar if required
        );
        } else {
          return const DemoPage();
        }
      },
    );
  }

  //         .collection('users/$userEmail/Groups')
  //         .snapshots(),
  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasData) {
  //         // make a list of cards of the groups that a user is in
  //         List<Widget> carouselItems = snapshot.data!.docs.map((document) {
  //           // make object view of each group a user is in
  //           Map<String, dynamic> groupData =
  //               document.data() as Map<String, dynamic>;

  //           return FutureBuilder(
  //               future: getProfURL(document.id),
  //               builder: (context, urlSnapShot) {
  //                 if (urlSnapShot.hasData) {
  //                   return Container(
  //                       child: _groupCard(groupData['groupName'],
  //                           groupData['groupID'], urlSnapShot.data));
  //                 } else {
  //                   return Container();
  //                 }
  //               });
  //         }).toList();

  //         // return CarouselSlider()

  //         // with those cards, make a carousel
  //         return CarouselSlider(
  //           items: carouselItems,
  //           options: CarouselOptions(
  //             height: 400,
  //             enlargeCenterPage: true,
  //             autoPlay: false,
  //             // autoPlayInterval: Duration(seconds: 5),
  //           ),
  //         );
  //         // );
  //       } else {
  //         return const DemoPage();
  //       }
  //     },
  //   );
  // }

  // the card representing a group a users in
  Widget _groupCard(String groupName, groupID, profPic, bool focused) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //const SizedBox(width: 50),
            Container(
              width: 250,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                //borderRadius: BorderRadius.circular(25),
                //color: const Color.fromARGB(255, 205, 201, 201),
                //border: Border.all(width: 2),
              ),
      child: Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    groupName,
                    style: const TextStyle(fontFamily: 'LeagueSpartan', fontSize: 30, fontWeight: FontWeight.bold,
),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(profPic),
                    radius: focused ? 70 : 20,
                    backgroundColor: Colors.grey,
                  ),
                ],
              ),
          )])));
  }

  Widget _joinGroupButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/joinGroup');
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          shape: const StadiumBorder(),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 20.0), // Adjust horizontal padding
          child: Text(
            'Join Group',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // button user presses create a group
  Widget _createGroupButton() {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pushNamed('/createGroup'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 117, 161, 15),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 50),
      ),
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
          title: const Text('                     Your Groups',
              style: TextStyle(color: Colors.black87, fontFamily: 'LeagueSpartan', fontSize: 25, fontWeight: FontWeight.bold)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // widgets
          children: [
            // MySearchBarWidget(),
            Expanded(child: _listGroups()),
            Container(
              width: 20,
              child: _joinGroupButton(),
            ),
            const SizedBox(
              height: 20,
            ),
            _createGroupButton()
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 117, 161, 15),
        bottomNavigationBar: MyBottomAppBar(),
      ),
    );
  }
}
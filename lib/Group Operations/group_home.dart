import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookmates_app/API/models/book.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({super.key});

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

// where the book cover will be located
Widget _bookContainer() {
  return Container(
    height: 300,
    width: 300,
    child: _bookCover(),
  );
}

Future<String?> getBookCoverUrl(String bookName) async {
  final encodedBookName = Uri.encodeComponent(bookName);
  final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=$encodedBookName');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['totalItems'] > 0) {
        final book = data['items'][0];
        final imageUrl = book['volumeInfo']['imageLinks']['thumbnail'];
        return imageUrl;
      } else {
        return null;
      }
    } else {
      print('Failed to load book data');
      return null;
    }
  } catch (e) {
    print('Error occurred: $e');
    return null;
  }
}

// the anatomy of a single profile pic and its username
Widget getProfileData(Map<String, dynamic> user) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80, bottom: 8, left: 8, right: 8),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user['profPicURL']),
                  radius: 50,
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(user['userName'],
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'Spartan',
              fontWeight: FontWeight.w600,
              color: Colors.white, // Text color
              shadows: [
                BoxShadow(
                  color: Color.fromRGBO(70, 70, 70, 0.918),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            )),
      ],
    ),
  );
}

// the output of all users with prof pics and usernames
Widget listOfGroupMembers() {
  return FutureBuilder<List<Map<String, dynamic>>?>(
      future: getListOfGroupMembers(),
      builder: (context, list) {
        if (list.hasData) {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return getProfileData(list.data![index]);
              });
        }
        return Container();
      });
}

// the progress bar, the title of the milestone with the actual bar
Widget loadingBar() {
  return FutureBuilder(
    future: getCurrentGroupID(),
    builder: (context, currentGroup) {
      if (currentGroup.hasData) {
        final currentGroupID = currentGroup.data;
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('groups')
              .doc(currentGroupID)
              .collection('Milestone')
              .snapshots(),
          builder: (context, groupMilestone) {
            if (groupMilestone.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (groupMilestone.hasData) {
              final milestoneList = ((groupMilestone.data)!.docs);
              if (milestoneList.isNotEmpty) {
                final milestone = milestoneList[0].data();
                return Container(
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF75A10F),
                  ),
                  child: Column(children: [
                    // the title of the milestone interface
                    SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          "Current Milestone",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Spartan',
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
                        )),
                    // the milestone name
                    SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "${milestone['goal']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 21,
                            fontFamily: 'Spartan',
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
                        )),

                    // the loading bar
                    SizedBox(
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Progress ${milestone['ratio'].round()}%",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontFamily: 'Spartan',
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
                        )),
                    SizedBox(
                      height: 40,
                      width: 300,
                      child: LinearProgressIndicator(
                        value: milestone['ratio'] / 100,
                        backgroundColor: Color.fromARGB(255, 240, 223, 173),
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: submitButton(context),
                    ),
                  ]),
                );
              }
            }
            // button to create a milestone
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF75A10F),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/milestonePage');
                      },
                      child: const Text(
                        "Create a milestone",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Spartan',
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
                    ),
                  ],
                ));
          },
        );
      } else {
        return Container();
      }
    },
  );
}

Widget submitButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 96, 133, 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 1.5))),
    onPressed: () async {
      if (await checkIfUserCompleted()) {
        // ignore: use_build_context_synchronously
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Congrats!'),
                content: const Text('You have already completed the Milestone'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ok')),
                ],
              );
            });
      } else {
        final milestone = await getCurrentMilestone();
        completeMilestone(milestone['id']);
      }
    },
    child: const Text(
      'Complete',
      style:
          TextStyle(fontFamily: 'Spartan', fontSize: 18, color: Colors.white),
    ),
  );
}

Future<Map<String, dynamic>?> getGroupData() async {
  final currentGroupID = await getCurrentGroupID();
  final snapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .get();
  final groupData = snapshot.data();
  return groupData;
}

Widget groupData() {
  return FutureBuilder(
      future: getGroupData(),
      builder: (context, groupSnapshot) {
        final groupData = groupSnapshot.data;
        if (groupData != null) {
          return SizedBox(
            width: 200,
            height: 100,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, right: 16, left: 16, top: 0),
                  child: Column(
                    children: [
                      Align(
                        child: Text(groupData['bookName'],
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Spartan',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                BoxShadow(
                                  color: Color.fromRGBO(70, 70, 70, 0.918),
                                  blurRadius: 12,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      });
}

class _GroupHomeState extends State<GroupHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundContainer(),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 250, child: listOfGroupMembers()),
          Positioned(
              top: 75,
              child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: groupData(),
              )),
          Positioned(top: 275, left: 140, child: _bookCover()),
          Positioned(
            top: 550,
            left: 25,
            right: 25,
            child: loadingBar(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _appBarWidget(),
          ),
        ],
      ),
    );
  }
}

// backgroud color of the join group page
Widget _backgroundContainer() {
  return Container(
    color: const Color(0xFF75A10F),
    height: double.infinity,
  );
}

// where the book cover will be located
Widget _bookCover() {
  return FutureBuilder(
    future: getGroupData()
        .then((groupData) => getBookCoverUrl(groupData?['bookName'])),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container();
      }
      if (snapshot.hasData && snapshot.data != null) {
        return Image.network(snapshot.data as String);
      }
      return const Text('Book Cover Not Available');
    },
  );
}

// the title of the page
Widget _appBarWidget() {
  return FutureBuilder(
    future: getGroupData(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: const EdgeInsets.only(
              top: 25,
              bottom: 30,
            ),
            child: Text(
              // output the name of the group
              snapshot.data!['groupName'],
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Spartan',
                fontWeight: FontWeight.bold,
                color: Colors.white, // Text color
                shadows: [
                  BoxShadow(
                    color: Color.fromRGBO(70, 70, 70, 0.918),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
        );
      } else
        return Container();
    },
  );
}

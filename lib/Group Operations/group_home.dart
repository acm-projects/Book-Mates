import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupHome extends StatefulWidget {
  const GroupHome({super.key});

  @override
  State<GroupHome> createState() => _GroupHomeState();
}

Future<String?> getCurrentGroupID() async {
  String? userEmail = FirebaseAuth.instance.currentUser?.email;
  final userData =
      FirebaseFirestore.instance.collection('users').doc(userEmail);
  final snapshot = await userData.get();
  Map<String, dynamic>? data = snapshot.data();
  if (data != null && data.containsKey('currentGroupID')) {
    return data['currentGroupID'];
  } else {
    return null;
  }
}

Future<List<Map<String, dynamic>>?> getListOfGroupMembers() async {
  String? currentGroupID = await getCurrentGroupID();
  List<Map<String, dynamic>> groupMembersList = [];
  final snapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Members')
      .get();
  final groupMembers = snapshot.docs;
  for (var member in groupMembers) {
    final data = member.data();
    groupMembersList.add(data);
  }
  return groupMembersList;
}

Widget getProfileData(Map<String, dynamic> user) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 50,
            height: 50,
            child: CircleAvatar(
              backgroundImage: NetworkImage(user['profPicURL']),
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            ),
          ),
          Text("User: ${user['userName']}",
            style: const TextStyle(
              fontSize: 15,
              fontFamily: 'LeagueSpartan',
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

Future<Map<String, dynamic>> getCurrentMilestone() async {
  final currentGroupID = await getCurrentGroupID();
  final snapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .collection('Milestone')
      .get();
  final milestone = (snapshot.docs)[0].data();
  return milestone;
}

Future<bool> checkIfUserCompleted() async {
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  final milestone = await getCurrentMilestone();

  List<String> userMilestoneList = [];
  final snapshot2 = await FirebaseFirestore.instance
      .collection('users')
      .doc(userEmail)
      .collection('completedMilestones')
      .get();
  final userMilestones = snapshot2.docs.toList();
  for (var data in userMilestones) {
    userMilestoneList.add(data.data()['id']);
  }
  // print(userMilestoneList);
  if (userMilestoneList.contains(milestone['id'])) {
    return true;
  } else {
    return false;
  }
}

Widget loadingBar() {
  return FutureBuilder(
    future: getCurrentGroupID(),
    builder: (context, currentGroup) {
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
              return Column(children: [
                SizedBox(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      "Current milestone",
                      textAlign: TextAlign.center,
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
                    )),
                SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "${milestone['goal']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 21,
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
                    )),
                SizedBox(
                    height: 35,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Progress ${milestone['ratio'].round()}%",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
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
                    )),
                SizedBox(
                  height: 20,
                  width: 300,
                  child: LinearProgressIndicator(
                    value: milestone['ratio'] / 100,
                    backgroundColor: Colors.amber,
                    color: const Color(0xFF75A10F),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: submitButton(context),
                ),
              ]);
            }
          }
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
                  ),
                ],
              ));
        },
      );
    },
  );
}

Widget submitButton(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF75A10F),
    ),
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
      style: TextStyle(
          fontFamily: 'LeagueSpartan', fontSize: 18, color: Colors.white),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Name: ${groupData['groupName']}",
                      style: const TextStyle(
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
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Bio: ${groupData['groupBio']}",
                      style: const TextStyle(
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
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Book: ${groupData['bookName']}",
                      style: const TextStyle(
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
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("ID: ${groupData['groupID']}",
                      style: const TextStyle(
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
                      )),
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
            top: 100,
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
          SizedBox(height: 320, child: listOfGroupMembers()),
          Positioned(
              top: 250,
              child: SizedBox(
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: groupData(),
              )),
          Positioned(
            top: 600,
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

// the title of the page
Widget _appBarWidget() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Container(
      padding: const EdgeInsets.only(
        top: 25,
      ),
      child: const Text(
        "Group Home",
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.w600,
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
}

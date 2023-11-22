import 'package:bookmates_app/Group%20Operations/group_home.dart';
import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/GroupChat/chat_page.dart';
import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:bookmates_app/demo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupWidgetTree extends StatefulWidget {
  const GroupWidgetTree({super.key});

  @override
  State<GroupWidgetTree> createState() => _GroupWidgetTreeState();
}

Future<int> getNumberOfGroupMembers() async {
  final currentGroupID = await getCurrentGroupID();
  final snapshot = await FirebaseFirestore.instance
      .collection('groups')
      .doc(currentGroupID)
      .get();
  final groupData = snapshot.data();
  int count = groupData?['memberCount'];
  return count;
}

class _GroupWidgetTreeState extends State<GroupWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getCurrentGroupID(),
        builder: (context, string) {
          final currentGroupID = string.data;
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(currentGroupID)
                  .collection('Milestone')
                  .snapshots(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (data != null) {
                  return FutureBuilder(
                      future: checkIfUserCompleted(),
                      builder: (context, check) {
                        return FutureBuilder(
                          future: getCurrentMilestone(),
                          builder: (context, milestone) {
                            return FutureBuilder(
                                future: getNumberOfGroupMembers(),
                                builder: (context, count) {
                                  if (count.data != 1 &&
                                      check.data == true &&
                                      milestone.data != null) {
                                    return ChatHome();
                                  }
                                  if (count.data != 1 &&
                                      check.data == false &&
                                      milestone.data != null) {
                                    return const GroupHome();
                                  } else if (count.data == 1 ||
                                      milestone.data == null) {
                                    return const GroupHome();
                                  } else {
                                    return const DemoPage();
                                  }
                                });
                          },
                        );
                      });
                }
                // used as the 'loading skeleton' of the widget tree, more seamless transition
                else {
                  return const DemoPage();
                }
              });
        });
  }
}

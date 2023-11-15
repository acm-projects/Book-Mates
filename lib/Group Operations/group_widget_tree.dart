import 'dart:io';

import 'package:bookmates_app/Group%20Operations/group_home.dart';
import 'package:bookmates_app/GroupChat/chat_page.dart';
import 'package:bookmates_app/demo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupWidgetTree extends StatefulWidget {
  const GroupWidgetTree({super.key});

  @override
  State<GroupWidgetTree> createState() => _GroupWidgetTreeState();
}

class _GroupWidgetTreeState extends State<GroupWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getCurrentGroupID(), builder: (context, string) {
      final currentGroupID = string.data;
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').doc(currentGroupID).collection('Milestone').snapshots(), 
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            return FutureBuilder(future: checkIfUserCompleted(), builder: (context, check) {
              if (check.data == true) {
                return const ChatHome();
              }
              else if (check.data == false) {
                return const GroupHome();
              }
              else {
                return const GroupHome();
              }
            });
          }
          else {
            return const DemoPage();
          }
        }
      );
    });
  }
}
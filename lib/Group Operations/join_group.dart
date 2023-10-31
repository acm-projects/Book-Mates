import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// page for user to join a group

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

final TextEditingController _controllerGroupId = TextEditingController();

class _JoinGroupState extends State<JoinGroup> {
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  var isJoin = true;
  String errorMsg = ""; // for error handling

  Widget _title() {
    // the title of the page
    return AppBar(
      title: const Text('Join Group Page'),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget _entryField(String hintText, TextEditingController controller) {
    // where users type in data
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Widget _submitButton() {
    // the submit button to join a group that will call  the join group function when pressed
    return ElevatedButton(
        onPressed: isJoin
            ? () async {
                await checkGroupExists(_controllerGroupId.text, 1);
              }
            : () async {
                await checkGroupExists(_controllerGroupId.text, 0);
              },
        child: Text(isJoin ? 'Join Group' : 'Leave Group'));
  }

  Widget _joinOrDeleteButton() {
    return TextButton(
      onPressed: () => setState(() {
        isJoin = !isJoin;
      }),
      child: Text(isJoin ? 'leave instead?' : 'join instead'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _title(),
          _entryField('Group ID', _controllerGroupId),
          _submitButton(),
          _joinOrDeleteButton(),
        ],
      ),
    );
  }
}

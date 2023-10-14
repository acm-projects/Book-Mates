import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final userEmail = Auth().currentUser?.email;

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

final TextEditingController _controllerGroupId = TextEditingController();

class _JoinGroupState extends State<JoinGroup> {
  var isJoin = true;
  String errorMsg = ""; // for error handling

  Future<void> joinGroup() async {
    final groupCollection =
        await FirebaseFirestore.instance.collection('groups').get();

    for (final groupDoc in groupCollection.docs) { // checks if the id that the user inputted exists, if it does, then add that user
      final groupID = groupDoc.id;
      if (_controllerGroupId.text == groupID) {
        await GroupRepo.memAdd(
            'groups/${_controllerGroupId.text}/Members', userEmail, 0);
        await GroupRepo.groupAdd('users/$userEmail/Groups',
            userEmail.toString(), _controllerGroupId.text);
      }
    }
  }

  Future<void> leaveGroup() async {
    // when user leaves the group
    await GroupRepo.leaveGroup(
        userEmail!,
        'groups/${_controllerGroupId.text}/Members',
        'users/$userEmail/Groups',
        _controllerGroupId.text);
  }

// ***********Widgets that make up the page ****************

  Widget _title() { // the title of the page
    return AppBar(
      title: const Text('Join Group Page'),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget _entryField(String hintText, TextEditingController controller) { // where users type in data
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
        onPressed: isJoin ? joinGroup : leaveGroup,
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

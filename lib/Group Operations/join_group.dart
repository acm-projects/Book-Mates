import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/auth.dart';
import 'package:flutter/material.dart';

final userEmail = Auth().currentUser?.email;

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final TextEditingController _controllerGroupId = TextEditingController();
  var isJoin = true;

  Future<void> joinGroup() async {

    await GroupRepo.memAdd('groups/${_controllerGroupId.text}/Members', userEmail, 0);
      
      await GroupRepo.groupAdd('users/$userEmail/Groups',userEmail!, _controllerGroupId.text);
  }

  Future<void> leaveGroup() async {// when user leaves the group
    await GroupRepo.leaveGroup(userEmail!,'groups/${_controllerGroupId.text}/Members', 'users/$userEmail/Groups', _controllerGroupId.text);
  }

// the following are widgets that make up the page

  Widget _title() {
    // the title of the page
    return AppBar(
      title: const Text('Join Group Page'),
      backgroundColor: Colors.lightGreen,
    );
  }

  Widget _entryField(String hintText, TextEditingController controller) {
    // modular entry field that can be resued at any time
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
          _entryField('Group u want 2 join', _controllerGroupId),
          _submitButton(),
          _joinOrDeleteButton(),
        ],
      ),
    );
  }
}

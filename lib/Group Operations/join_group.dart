import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/auth.dart';
import 'package:flutter/material.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final TextEditingController _controllerGroupId = TextEditingController();
  var isJoin = true;

  Future<void> joinGroup() async {
    final userEmail = Auth().currentUser?.email;

    GroupRepo.memAdd(
        'groups/${_controllerGroupId.text}/Members', userEmail, 0);
  }

  Future<void> leaveGroup() async {
    // trying to kick the user from the id they've just submitted, _controllerGroupId has this id
    final userEmail = Auth().currentUser?.email;

    await GroupRepo.mainDelete(
        userEmail!, 'groups/${_controllerGroupId.text}/Members');
  }

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

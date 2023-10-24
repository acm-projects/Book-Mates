import 'package:bookmates_app/Group%20Operations/delete_page.dart';
import 'package:bookmates_app/Group%20Operations/group_model.dart';
import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateOrDeleteGroup extends StatefulWidget {
  const CreateOrDeleteGroup({super.key});

  @override
  State<CreateOrDeleteGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateOrDeleteGroup> {
  var isCreate = true;

  final TextEditingController _controllerGroupName =
      TextEditingController(); // variables that hold the data that users type in any entryfield
  final TextEditingController _controllerGroupBio = TextEditingController();
  final TextEditingController _controllerBookName = TextEditingController();
  final TextEditingController _controllerGroupID = TextEditingController();

  Future<void> createGroup() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    final newGroupModel = GroupModel(
      bookName: _controllerBookName.text,
      groupBio: _controllerGroupBio.text,
      groupID: _controllerGroupID.text,
      groupName: _controllerGroupName.text,
    );

    await GroupRepo.createOrUpdate(
        newGroupModel); // this instantiates the data fields in each document of the collection 'groups'

    await GroupRepo.msgAdd('groups/${_controllerGroupID.text}/Messages',
        userEmail, "", 'text', "");
    await GroupRepo.memAdd(
        'groups/${_controllerGroupID.text}/Members', userEmail, 1);
    await GroupRepo.milestoneAdd('groups/${_controllerGroupID.text}/Milestone',
        userEmail!, _controllerGroupID.text);
    await GroupRepo.groupAdd(
        'users/$userEmail/Groups', userEmail, _controllerGroupID.text);
  }

  // *************the following are widgets that make up the screen******************

  Widget _createGroupOrDeleteButton() {
    return TextButton(
      onPressed: () => setState(() {
        // if the login or register button is pressed, change the value of isLogin to switch between the 2 possible functions, signing in and registering
        isCreate = !isCreate;
      }),
      child: Text(isCreate
          ? 'delete instead?'
          : 'create group instead?'), // changes the text of the button to tell  the user the other option based on the truth values of this flag
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    // this will be the line where the user actually types in the data
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isCreate
            ? createGroup
            : () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (const DeletePage()),
                )), //if the button is pressed, based on the data field isLogin, if its true, that means we login in, and call the respected method, is not, call the regiser user function
        child: Text(isCreate
                ? 'Create'
                : 'Delete' //based on the _loginOrregisterButton, which changes the value of the flag isLogin, print out login or register to not have to make another page
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating or Deleting Group"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _entryField('Book Name', _controllerBookName),
          _entryField("Group Bio", _controllerGroupBio),
          _entryField('Group Name', _controllerGroupName),
          _entryField('Group ID', _controllerGroupID),
          _submitButton(),
          _createGroupOrDeleteButton(),
        ],
      ),
    );
  }
}

import 'package:bookmates_app/Group%20Operations/delete_page.dart';
import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateOrDeleteGroup extends StatefulWidget {
  const CreateOrDeleteGroup({super.key});

  @override
  State<CreateOrDeleteGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateOrDeleteGroup> {
  // flag changing verbose and functionallity
  var isCreate = true;

  // holding user input
  final TextEditingController _controllerGroupName = TextEditingController();
  final TextEditingController _controllerGroupBio = TextEditingController();
  final TextEditingController _controllerBookName = TextEditingController();
  final TextEditingController _controllerGroupID = TextEditingController();
  //holding the user's email
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  Widget _createGroupOrDeleteButton() {
    return TextButton(
      onPressed: () => setState(() {
        isCreate = !isCreate;
      }),
      child: Text(isCreate ? 'delete instead?' : 'create group instead?'),
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
            ? () async {
                createOrUpdate(
                    _controllerBookName.text,
                    _controllerGroupBio.text,
                    _controllerGroupName.text,
                    _controllerGroupID.text,
                    userEmail);
              }
            : () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => (const DeletePage()),
                )),
        child: Text(isCreate ? 'Create' : 'Delete'));
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

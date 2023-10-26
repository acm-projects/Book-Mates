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

    await GroupRepo.msgAdd(
        path: 'groups/${_controllerGroupID.text}/Messages',
        userEmail: userEmail,
        msgContent: "");
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
      onPressed: createGroup, // Call the createGroup function directly
      child: Text(''),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 16.0), // Add some horizontal margin
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'LeagueSpartan', // Set the font family
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(), // Add a border to the input field
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.0), // Adjust padding
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isCreate
          ? createGroup
          : () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => (const DeletePage()),
              )),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF75A10F), // Set the button background color to green
      ),
      child: Text(
        isCreate ? 'Create' : 'or Join a Group',
        style: TextStyle(
          fontFamily: 'LeagueSpartan', // Set the font family to League Spartan
          fontSize: 18, // Adjust the font size as needed
          color: Colors.white, // Set the text color to white
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF75A10F), // Background color
            height: double.infinity,
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173), // Tan color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  _entryField('Book Name', _controllerBookName),
                  SizedBox(height: 16),
                  _entryField("Group Bio", _controllerGroupBio),
                  SizedBox(height: 16),
                  _entryField('Group Name', _controllerGroupName),
                  SizedBox(height: 16),
                  _entryField('Group ID', _controllerGroupID),
                  SizedBox(height: 16),
                  _submitButton(),
                  SizedBox(height: 16),
                  _createGroupOrDeleteButton(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              automaticallyImplyLeading: false,
              title: Container(
                padding: EdgeInsets.only(
                  top: 25,
                ),
                child: Text(
                  "Create your group",
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
            ),
          ),
        ],
      ),
    );
  }
}

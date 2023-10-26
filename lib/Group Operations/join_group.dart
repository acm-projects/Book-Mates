import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:bookmates_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final userEmail = Auth().currentUser?.email;

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key});

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

    for (final groupDoc in groupCollection.docs) {
      // checks if the id that the user inputted exists, if it does, then add that user
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
    // when the user leaves the group
    await GroupRepo.leaveGroup(
        userEmail!,
        'groups/${_controllerGroupId.text}/Members',
        'users/$userEmail/Groups',
        _controllerGroupId.text);
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: 'LeagueSpartan',
      fontSize: 18,
      color: Colors.white, // Adjust the text color to white
    );
  }

  Widget _title() {
    // the title of the page
    return AppBar(
      title: Text(
        'Join a Group',
        style: _textStyle(),
      ),
      backgroundColor: Color(0xFF75A10F), // Use the green color
    );
  }

  Widget _entryField(String hintText, TextEditingController controller) {
    // where users type in data
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 16.0), // Add some horizontal margin
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white, // Adjust the text color to white
        ),
        decoration: InputDecoration(
          labelText: hintText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
        ),
      ),
    );
  }

  Widget _submitButton() {
    // the submit button to join a group that will call the join group function when pressed
    return ElevatedButton(
      onPressed: isJoin ? joinGroup : leaveGroup,
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF75A10F), // Set the button background color to green
      ),
      child: Text(
        isJoin ? 'Join Group' : '',
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _joinOrDeleteButton() {
    return TextButton(
      onPressed: () => setState(() {
        isJoin = !isJoin;
      }),
      child: Text(
        isJoin ? '' : 'Join Instead',
        style: _textStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back arrow
        title: Center(
          // Centers the title
          child: Text(
            'Join Group Page',
            style: TextStyle(
              fontFamily: 'LeagueSpartan',
              color: Colors.white, // Set text color to white
            ),
          ),
        ),
        backgroundColor: Color(0xFF75A10F), // Make the app bar transparent
        elevation: 0, // Remove the shadow/elevation
      ),
      body: Stack(
        children: [
          Container(
            color: Color(0xFF75A10F), // Set the background color to green
            height: double.infinity, // Take up the full height
          ),
          Positioned(
            top: 0, // Position the tan part at the top
            left: 0,
            right: 0,
            bottom: 0, // Extend the tan part to the bottom
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(
                  255,
                  240,
                  223,
                  173,
                ), // Your desired tan color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 100), // Add spacing at the top
                  _entryField('Group ID', _controllerGroupId),
                  SizedBox(height: 16),
                  _submitButton(),
                  SizedBox(height: 16),
                  _joinOrDeleteButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:bookmates_app/auth.dart';
import 'package:bookmates_app/widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  // the controllers for the new data to be written in this page
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerNewUserName = TextEditingController();

  //flag indicating wether user wants to update or delete their account
  bool isUpdate = true;

  Widget _entryField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Future<void> updateUserInformation() async {
    var db = FirebaseFirestore.instance;
    var auth = FirebaseAuth.instance;

    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    final currentUserReference = db.collection("users").doc(currentUserEmail);

    currentUserReference.update({"Password": _controllerNewPassword.text});
    currentUserReference.update({"userName": _controllerNewUserName.text});

    auth.currentUser?.updatePassword(_controllerNewPassword.text);
  }

  Widget _submitButton() {
    // button that either says delete or update user, based on if user presses the testButton
    return ElevatedButton(
        onPressed: () async => {
              isUpdate ? updateUserInformation() : deleteUser(),
              Auth().signOut(),
              Navigator.of(context).pop(MaterialPageRoute(
                builder: (context) => const WidgetTree(),
              ))
            },
        child: Text(isUpdate ? 'Update User' : "Delete User"));
  }

  Future<void> deleteUser() async {
    var db = FirebaseFirestore.instance;

    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    db.collection("users").doc(currentUserEmail).delete();
    var auth = FirebaseAuth.instance;

    auth.currentUser?.delete();
  }

  Widget _updateOrDeleteButton() {
    return TextButton(
        onPressed: () => setState(() {
              // if the login or register button is pressed, change the value/state of isLogin to switch between the 2 possible functions, signing in and registering
              isUpdate = !isUpdate;
            }),
        child: Text(
          isUpdate ? 'Delete User' : 'saveChanges',
          style: TextStyle(
            color: isUpdate ? Colors.red : Colors.blue,
          ),
        ) // changes the text of the button to tell  the user the other option based on the truth values of this flag
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Current User")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // _entryField("New Email", _controllerNewEmail),
            _entryField("New Password", _controllerNewPassword),
            _entryField("New UserName", _controllerNewUserName),
            _submitButton(),
            _updateOrDeleteButton(),
          ],
        ),
      ),
    );
  }
}

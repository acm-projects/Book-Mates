import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_repo.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditUserPage> {
  //variables that hold the users data
  final TextEditingController _controllerNewPassword = TextEditingController();
  final TextEditingController _controllerNewUserName = TextEditingController();
  // email of current user
  final email = FirebaseAuth.instance.currentUser?.email;

  Widget _entryField(String hintText, TextEditingController controller) {
    // generalized widget to take in user data
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Widget _submitButton() {
    // button that either says delete or update user, based on if user presses the testButton
    return ElevatedButton(
        onPressed: () async {
          await createUser(
              _controllerNewUserName.text, _controllerNewPassword.text, email);
          await FirebaseAuth.instance.currentUser
              ?.updatePassword(_controllerNewPassword.text);
        },
        child: const Text('Update User information'));
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
          ],
        ),
      ),
    );
  }
}

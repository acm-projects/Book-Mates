import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DeletePage> {
  // hold ID of the group the user inputs
  final TextEditingController _controllerGroupID = TextEditingController();
  // hold user's email
  final userEmail = FirebaseAuth.instance.currentUser?.email;
  Widget _finalDelete(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
        onPressed: () async {
          await deleteGroup(_controllerGroupID.text, userEmail);
        },
        child: const Text('Delete for good'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deleting Group"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _finalDelete(_controllerGroupID, 'GroupID'),
          _button(),
        ],
      ),
    );
  }
}

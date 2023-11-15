import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MilestoneListPage extends StatefulWidget {
  const MilestoneListPage({Key? key}) : super(key: key);

  @override
  State<MilestoneListPage> createState() => _MilestoneListPageState();
}

class _MilestoneListPageState extends State<MilestoneListPage> {
  // variables holding user input
  final _milestoneBodyController = TextEditingController();
  final _milestoneDeadlineController = TextEditingController();

  // user's email
  final userEmail = FirebaseAuth.instance.currentUser?.email;

  // to prompt user input
  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
        ),
      ),
    );
  }

  // to create a milestone
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        // convert user input into int
        final deadline = int.tryParse(_milestoneDeadlineController.text);
        // check if user input is valid and text is not empty
        if (_milestoneBodyController.text.isNotEmpty && deadline! > 0) {
          createMilestone(_milestoneBodyController.text, deadline);
          // clear both inputs
          _milestoneBodyController.clear();
          _milestoneDeadlineController.clear();
          // update the UI after submission
          Navigator.of(context).pop();
        }
      },
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF75A10F),
      ),
      child: const Text(
        'Create Milestone',
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  // the main of flutter, all widgets called here will show up on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones List'),
        backgroundColor: const Color(0xFF75A10F),
      ),
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF75A10F),
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              // user input
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  _entryField('Enter Goal', _milestoneBodyController),
                  const SizedBox(height: 16),
                  _entryField(
                    'Milestone Deadline (in days)',
                    _milestoneDeadlineController,
                  ),
                  const SizedBox(height: 16),
                  _submitButton(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

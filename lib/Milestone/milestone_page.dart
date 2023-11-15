import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MilestoneListPage extends StatefulWidget {
  const MilestoneListPage({super.key});
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
  Widget _entryField(TextEditingController controller, String headerText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: headerText,
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
            //clear both inputs
            _milestoneBodyController.clear();
            _milestoneDeadlineController.clear();
            // update the UI after submission
            Navigator.of(context).pop();
          }
        },
        child: const Text('Create Milestone'));
  }

  // the main of flutter, all widgets called here will show up on the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMilestonesData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Check the number of documents in the collection
            final milestoneList = snapshot.data;

            return Column(
              children: <Widget>[
                // can only have one milestone at a time
                if (milestoneList!.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _entryField(_milestoneBodyController, 'Enter Goal'),
                        _entryField(_milestoneDeadlineController,
                            'Milestone Deadline (in days)'),
                        _submitButton(),
                      ],
                    ),
                  ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

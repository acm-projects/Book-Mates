import 'package:bookmates_app/Milestone/milestone_service.dart';
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

  Widget _entryField(TextEditingController controller, String headerText) {
    // to prompt user input
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: headerText,
      ),
    );
  }

  Widget _submitButton() {
    // to create a milestone
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
            setState(() {});
          }
        },
        child: const Text('Create Milestone'));
  }

  Widget _listMilestones(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    // to output all uncompleted milestones
    return ListView.builder(
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final milestoneData = snapshot.data![index];
        final milestoneID = milestoneData['id'].toString();
        return ListTile(
          title: Text(milestoneData['goal'].toString()),
          subtitle: Text('Progress Ratio: ${milestoneData['ratio']}%'),
          trailing: ElevatedButton(
            onPressed: () {
              completeMilestone(milestoneID);
              setState(() {});
              Navigator.popAndPushNamed(context, '/milestonePage');
            },
            child: const Text('Complete'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milestones List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMilestonesData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the list of milestones with buttons to update progress
            return Column(
              children: [
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
                Expanded(
                  child: _listMilestones(snapshot),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

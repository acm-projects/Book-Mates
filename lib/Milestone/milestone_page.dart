import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:flutter/material.dart';

class MilestoneListPage extends StatefulWidget {
  const MilestoneListPage({super.key});
  @override
  State<MilestoneListPage> createState() => _MilestoneListPageState();
}

class _MilestoneListPageState extends State<MilestoneListPage> {
  final TextEditingController _milestoneBodyController =
      TextEditingController();
  final TextEditingController _milestoneDeadlineController =
      TextEditingController();

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
                      TextFormField(
                        controller: _milestoneBodyController,
                        decoration:
                            const InputDecoration(labelText: 'Milestone'),
                      ),
                      TextFormField(
                        controller: _milestoneDeadlineController,
                        decoration: const InputDecoration(
                            labelText: 'Milestone Deadline (in days)'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Create a new milestone when the button is pressed
                          final milestoneBody = _milestoneBodyController.text;
                          final deadline =
                              int.tryParse(_milestoneDeadlineController.text) ??
                                  0;
                          if (milestoneBody.isNotEmpty && deadline > 0) {
                            createMilestone(milestoneBody, deadline);
                            _milestoneBodyController.clear();
                            _milestoneDeadlineController.clear();
                            setState(() {});
                          }
                        },
                        child: const Text('Create Milestone'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      final milestoneData = snapshot.data![index];
                      final milestoneID = milestoneData['id'].toString();
                      return ListTile(
                        title: Text(milestoneData['goal'].toString()),
                        subtitle:
                            Text('Progress Ratio: ${milestoneData['ratio']}%'),
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
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

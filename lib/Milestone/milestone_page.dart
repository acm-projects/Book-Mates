import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'milestone_service.dart';
import 'milestone_model.dart';
// [Your other code: MilestoneModel, MilestoneService, etc. here]

class MilestoneTester extends StatefulWidget {
  @override
  _MilestoneTesterState createState() => _MilestoneTesterState();
}

class _MilestoneTesterState extends State<MilestoneTester> {
  final MilestoneService _milestoneService = MilestoneService();
  final String testGroupId = "yourTestGroupIdHere"; // Replace with your test group ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Milestone Tester')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MilestoneModel>>(
              stream: _milestoneService.getMilestones(testGroupId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final milestone = snapshot.data![index];
                    return ListTile(
                      title: Text(milestone.milestoneName),
                      subtitle: Text('Progress: ${milestone.progress * 100}%'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await _milestoneService.isCompleted(testGroupId, milestone.milestoneId);
                        },
                        child: Text('Complete'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final dummyMilestone = MilestoneModel(
                milestoneName: 'Test Milestone',
                milestoneId: 'dummyId${DateTime.now().millisecondsSinceEpoch}', // just for uniqueness
                totalMembers: 10,
                completedMembers: 0,
              );
              await _milestoneService.createMilestone(testGroupId, dummyMilestone);
            },
            child: Text('Add Milestone'),
          ),
        ],
      ),
    );
  }
}

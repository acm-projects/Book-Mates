import 'dart:io';

import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';

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

  Widget _progressBar(dynamic ratio, double height, width, String milestoneID) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Container(
                width: width * (ratio / 100),
                height: height,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${ratio}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ),
        // button user presses to update the ratio
        ElevatedButton(
          onPressed: () async {
            await completeMilestone(milestoneID);
            setState(() async {
              // ratio = await getRatio(milestoneID);
            });
          },
          child: const Text('Complete'),
        ),
      ],
    );
  }

  // Widget _listMilestones(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
  //   // to output all uncompleted milestones
  //   return ListView.builder(
  //     itemCount: snapshot.data?.length,
  //     itemBuilder: (context, index) {
  //       final milestoneData = snapshot.data![index];
  //       final milestoneID = milestoneData['id'].toString();
  //       return ListTile(
  //         title: Text(milestoneData['goal'].toString()),
  //         subtitle: Text('Progress Ratio: ${milestoneData['ratio']}%'),
  //         trailing: ElevatedButton(
  //           onPressed: () {
  //             completeMilestone(milestoneID);
  //             setState(() {});
  //             Navigator.popAndPushNamed(context, '/milestonePage');
  //           },
  //           child: const Text('Complete'),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _listMilestones(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    // to output all uncompleted milestones
    return ListView.builder(
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        final milestoneData = snapshot.data![index];
        final milestoneID = milestoneData['id'].toString();
        print(milestoneID);
        // final ratio = milestoneData['ratio'];

        return FutureBuilder<String?>(
          future: getCurrentGroupID(),
          builder: (context, groupIDSnapshot) {
            // get the groupID from the snapshot
            final groupID = groupIDSnapshot.data;
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('groups/$groupID/Milestone')
                  .doc(milestoneID)
                  .snapshots(),
              builder: (context, milestoneSnapshot) {
                // update the ratio of the milestone every click
                if (milestoneSnapshot.hasData) {
                  sleep(const Duration(seconds: 2));
                  dynamic updatedRatio = milestoneSnapshot.data?['ratio'];
                  if (updatedRatio != null) {
                    print(updatedRatio);
                  }
                  return CircularProgressIndicator();
                  // final updatedRatio = milestoneSnapshot.data!['ratio'];
                  // return _progressBar(updatedRatio, 20, 200, milestoneID);
                }
                return Container();
              },
            );
          },
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

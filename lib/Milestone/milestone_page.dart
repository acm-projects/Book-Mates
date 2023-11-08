import 'package:bookmates_app/Milestone/milestone_service.dart';
import 'package:bookmates_app/Notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            setState(() {});
          }
        },
        child: const Text('Create Milestone'));
  }

  // makeshift progress bar that increases based on a 'ratio' data field in firestore
  Widget _progressBar(dynamic ratio, double height, width, String milestoneID,
      bool showButton) {
    return Center(
      // Center the _progressBar
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the Row horizontally
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Container(
                  // gets larger as the ratio increases
                  width: width * (ratio / 100),
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    // show the ratio on the bar
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
          _completeMilestoneButton(milestoneID, showButton),
        ],
      ),
    );
  }

  // button user presses to complete a milestone
  Widget _completeMilestoneButton(String milestoneID, bool userCompleted) {
    return ElevatedButton(
        onPressed: () async {
          if (userCompleted) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('ERROR!!!'),
                    content:
                        const Text('You have already completed the Milestone'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ok')),
                    ],
                  );
                });
          } else {
            // complete milestone functionality
            await completeMilestone(milestoneID);
            // update UI after press
            // setState(() {});
          }
        },
        child: const Text('Finish'));
  }

  Widget _listMilestones(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    // to output all uncompleted milestones in a group
    return ListView.builder(
      itemCount: snapshot.data?.length,
      itemBuilder: (context, index) {
        // the data of this snapshot
        final milestoneData = snapshot.data![index];
        // the docID of the milestone subcollection in 'groups'
        final milestoneID = milestoneData['id'].toString();

        return FutureBuilder<String?>(
          // wait for the current group ID so we can access the specific milestone live
          future: getCurrentGroupID(),
          builder: (context, groupIDSnapshot) {
            // get the groupID from the snapshot
            final groupID = groupIDSnapshot.data;

            // streamBuilder to get completedMilestone info
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users/$userEmail/completedMilestones')
                    .snapshots(),
                builder: (context, completedSnapshot) {
                  if (completedSnapshot.hasData) {
                    // assuming the user has not completed the milestone
                    bool userCompleted = false;

                    // go through the entire subcollection in user to find
                    // the id, if it is present

                    for (QueryDocumentSnapshot completedDoc
                        in completedSnapshot.data!.docs) {
                      // the completedDoc represents one document in the subcollection
                      //check if the 'id' is =2 the current milestone
                      if (completedDoc['id'] == milestoneID) {
                        userCompleted = true;
                        break;
                      }
                    }
                    // streamBuilder to get milestone ratio
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups/$groupID/Milestone')
                          .doc(milestoneID)
                          .snapshots(),
                      builder: (context, milestoneSnapshot) {
                        if (milestoneSnapshot.hasData &&
                            milestoneSnapshot.data!.exists) {
                          // fetch the ratio and update/create the progress widget
                          final updatedRatio = milestoneSnapshot.data!['ratio'];
                          return _progressBar(updatedRatio, 20, 200,
                              milestoneID, userCompleted);
                        }
                        // return nothing if no data is loaded
                        return Container();
                      },
                    );
                  }
                  // show something if it hasn't loaded yet
                  return Container();
                });
          },
        );
      },
    );
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
                Expanded(
                  child: _listMilestones(snapshot),
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

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
                  child:
                      // show the ratio on the bar
                      Text(
                    '${ratio}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ),
        // button user presses to increase the ratio
        if (!showButton)
          ElevatedButton(
            onPressed: () async {
              await completeMilestone(milestoneID);
              // update UI after press
              setState(() {});
            },
            child: const Text('Complete'),
          ),
      ],
    );
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
          // wait for the current group ID so we can acess the specific milestone live
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
                  if (completedSnapshot.connectionState ==
                      ConnectionState.waiting)
                    return CircularProgressIndicator();
                  else if (completedSnapshot.hasError)
                    return Text('${completedSnapshot.error}');
                  else if (completedSnapshot.hasData) {
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

                    // if the user has NOT completed the milestone, show
                    // this _progressBar widget

                    // streamBuilder to get milestone ratio
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('groups/$groupID/Milestone')
                          .doc(milestoneID)
                          .snapshots(),
                      builder: (context, milestoneSnapshot) {
                        if (milestoneSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (milestoneSnapshot.hasError) {
                          return Text('Error: ${milestoneSnapshot.error}');
                        } else if (milestoneSnapshot.hasData &&
                            milestoneSnapshot.data!.exists) {
                          // fetch the ratio and update/create the progress widget
                          final updatedRatio = milestoneSnapshot.data!['ratio'];
                          return _progressBar(updatedRatio, 20, 200,
                              milestoneID, userCompleted);
                        } else {
                          // Handle the case when the document doesn't exist
                          return Container();
                        }
                      },
                    );
                  }

                  // if the user has completed the milestone, dont show
                  return Container();
                });
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

import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DeletePage> {
  final TextEditingController _controllerGroupID = TextEditingController();

  Future<void> deleteGroup() async {
    // final userEmail = Auth().currentUser?.email;
    // want to delete the entire group
    final subRef1 =
        'groups/${_controllerGroupID.text}/Members'; // refrecnces to the 2 subcollections of a document in the collection 'groups'
    final subRef2 = 'groups/${_controllerGroupID.text}/Messages';

    GroupRepo.subDelete(subRef1);
    GroupRepo.subDelete(subRef2);

    GroupRepo.mainDelete(_controllerGroupID.text, 'groups');
  }

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
        onPressed: () {
          deleteGroup();
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

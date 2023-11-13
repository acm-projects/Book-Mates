import 'package:flutter/material.dart';
import 'package:bookmates_app/Group Operations/delete_page.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroupScreen> {
  var isCreate = true;

  final TextEditingController _controllerGroupName = TextEditingController();
  final TextEditingController _controllerGroupBio = TextEditingController();
  final TextEditingController _controllerBookName = TextEditingController();
  final TextEditingController _controllerGroupID = TextEditingController();

  void createGroup() {
    print('Creating group...');
  }

  Widget _createGroupOrDeleteButton() {
    return TextButton(
      onPressed: () {
        // Update isCreate and trigger a rebuild
        setState(() {
          isCreate = !isCreate;
        });
      },
      child: Text(isCreate ? 'Switch to Join' : 'Switch to Create'),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'LeagueSpartan',
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isCreate
          ? createGroup
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DeletePage(),
                ),
              ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF75A10F),
      ),
      child: Text(
        isCreate ? 'Create' : 'Join a Group',
        style: const TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Color(0xFF75A10F),
              height: double.infinity,
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 223, 173),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    _entryField('Book Name', _controllerBookName),
                    SizedBox(height: 16),
                    _entryField("Group Bio", _controllerGroupBio),
                    SizedBox(height: 16),
                    _entryField('Group Name', _controllerGroupName),
                    SizedBox(height: 16),
                    _entryField('Group ID', _controllerGroupID),
                    SizedBox(height: 16),
                    _submitButton(),
                    SizedBox(height: 16),
                    _createGroupOrDeleteButton(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  padding: EdgeInsets.only(
                    top: 25,
                  ),
                  child: Text(
                    "Create your group",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'LeagueSpartan',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                          color: Color.fromRGBO(70, 70, 70, 0.918),
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

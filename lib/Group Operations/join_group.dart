import 'package:bookmates_app/Group%20Operations/group_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

// variable to hold user input
final _controllerVerificationCode = TextEditingController();

class _JoinGroupState extends State<JoinGroup> {
  // output any errors user might encounter joining a group
  String errorMsg = "";

  // button to join a group
  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () async {
        // navigate to homepage after joining a group
        Navigator.of(context).popAndPushNamed('/homePage');
        // check group existence before joining
        await checkGroupExists(_controllerVerificationCode.text, 1);
      },
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF75A10F),
      ),
      child: const Text(
        'Join Group',
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  // backgroud color of the join group page
  Widget _backgroundContainer() {
    return Container(
      color: const Color(0xFF75A10F),
      height: double.infinity,
    );
  }

  // 6 digits user types in to join a group
  Widget _verificationCodeWidget() {
    return Column(
      children: [
        const SizedBox(height: 100),
        VerificationCode(
          length: 6,
          textStyle: const TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: 18,
            color: Colors.white,
          ),
          keyboardType: TextInputType.number,
          onCompleted: (String value) {
            // update variable holding user input
            _controllerVerificationCode.text = value;
          },
          onEditing: (bool value) {
            if (!value) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
        const SizedBox(height: 16),
        _submitButton(),
      ],
    );
  }

// the title of the page
  Widget _appBarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(
          top: 25,
        ),
        child: const Text(
          "Join a Group",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'LeagueSpartan',
            fontWeight: FontWeight.w600,
            color: Colors.white, // Text color
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
    );
  }

  // the 'main' of flutter, where are all the widgets are called
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _backgroundContainer(),
          Positioned(
            top: 100,
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
              child: _verificationCodeWidget(),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _appBarWidget(),
          ),
        ],
      ),
    );
  }
}

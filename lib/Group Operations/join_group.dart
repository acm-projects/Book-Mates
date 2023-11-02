import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

final TextEditingController _controllerVerificationCode =
    TextEditingController();

class _JoinGroupState extends State<JoinGroup> {
  String errorMsg = "";

  Future<void> joinGroupWithVerificationCode() async {
    final verificationCode = _controllerVerificationCode.text;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Verify the code and join the group.
        if (verificationCode.isNotEmpty) {
          final userEmail = user.email;

          // Replace these with your Firestore collection paths and logic.
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(verificationCode)
              .update({
            'members': FieldValue.arrayUnion([userEmail]),
          });

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userEmail)
              .update({
            'groups': FieldValue.arrayUnion([verificationCode]),
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMsg = "Error: $e"; // Handle any errors
      });
    }
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: 'LeagueSpartan',
      fontSize: 18,
      color: Colors.white,
    );
  }

  Widget _title() {
    return AppBar(
      title: Text(
        'Join a Group',
        style: _textStyle(),
      ),
      backgroundColor: Color(0xFF75A10F),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: joinGroupWithVerificationCode,
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF75A10F),
      ),
      child: Text(
        'Join Group',
        style: TextStyle(
          fontFamily: 'LeagueSpartan',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF75A10F), // Background color
            height: double.infinity,
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 223, 173), // Tan color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  VerificationCode(
                    length: 6,
                    textStyle: TextStyle(
                      fontFamily: 'LeagueSpartan',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onCompleted: (String value) {
                      // Handle the completed verification code
                      _controllerVerificationCode.text = value;
                    },
                    onEditing: (bool value) {
                      // Handle the editing state, for example, unfocus the text field when editing is complete
                      if (!value) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  _submitButton(),
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
            ),
          ),
        ],
      ),
    );
  }
}

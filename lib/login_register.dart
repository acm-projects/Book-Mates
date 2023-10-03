import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookmates_app/auth.dart';

//the page where the user will see first, option to sign in or register account


class LoginPage extends StatefulWidget {
  // stateful, meaning, data will change and cause re-render due to the action of logging in, or the state of the error msg, if any
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMsg =
      ""; // empty string for any error that might output, if there is one, then any catch will get it and set its text property to a string to output for the user
  bool isLogin =
      true; //flag that indicates the purpose of the button, wether that be to sign in, or make a new account, defualt is signing in

  final TextEditingController _controllerEmail =
      TextEditingController(); // the TextEditingController is a class used to control and manipulate the content of a text input field
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    // Future is an asynchronous operation that represents a potentially long-running task. It's a way to work with code that doesn't block the main thread, the void is just the return type of this async function
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword
              .text); // try to signInWithEmailAndPassword by using the Auth class function defined previously using the fields the user typed in
    } on FirebaseAuthException catch (error) {
      // if there is an exeption in this classes function, which will always be of type FirebaseAuth, then catch the error;
      setState(() {
        errorMsg = error
            .message!; // set the error's message to the data field errorMsg, the '!; means it can never be null, to prevent any issue
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    // Create variable for firestore db so we can insert data
    var db = FirebaseFirestore.instance;
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      // Create dictionary for user info
      final user = <String, dynamic>{
        "Email": _controllerEmail.text,
        "Password": _controllerPassword.text,
        "userName": _controllerUserName.text,
      };

      // Now insert data into databse with custom ID
      db.collection("users").doc(_controllerEmail.text).set(user);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message!;
      });
    }
  }

  // the following are Widgets that will make up this login/register pag

  Widget _title() {
    return const Text('This is the title');
  }

  Widget _entryField(String title, TextEditingController controller) {
    // this will be the line where the user actually types in the data
    return TextField(
      controller:
          controller, // the controller will either be the _controllerEmail or _controllerPassword that is passed in this widget
      decoration: InputDecoration(
        labelText:
            title, // the word 'email' or 'password' that will label the input field
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMsg == ""
        ? ""
        : errorMsg); // if the errorMsg data field found an error while trying the FirebaseAuth's methods, then output it under the password text field, if not, output an empty string
  }

  Widget _loginOrregisterButton() {
    return TextButton(
      onPressed: () => setState(() {
        // if the login or register button is pressed, change the value of isLogin to switch between the 2 possible functions, signing in and registering
        isLogin = !isLogin;
      }),
      child: Text(isLogin
          ? 'register instead'
          : 'login instead'), // changes the text of the button to tell  the user the other option based on the truth values of this flag
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword, //if the button is pressed, based on the data field isLogin, if its true, that means we login in, and call the respected method, is not, call the regiser user function
        child: Text(isLogin
                ? 'Login'
                : 'Register' //based on the _loginOrregisterButton, which changes the value of the flag isLogin, print out login or register to not have to make another page
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding:
            const EdgeInsets.all(20), // have padding all around for the widgets
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // move the column horizontally to the center of the page
          mainAxisAlignment: MainAxisAlignment
              .center, // move all widgets vertically to the center
          children: <Widget>[
            _entryField('Email',
                _controllerEmail), // display a text field with title email and text be recorded from the user be the data field _controllerEmail
            _entryField('Password',
                _controllerPassword), // display a text field with title password and text be recorded from the user be the data field _controllerPassword
            _entryField('Username', _controllerUserName),
            _errorMessage(),
            _submitButton(),
            _loginOrregisterButton(),
          ],
        ),
      ),
    );
  }
}

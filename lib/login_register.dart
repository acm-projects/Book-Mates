import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//the page where the user will see first, option to sign in or register account

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  String errorMsg = "";

  bool isLogin =
      true; //flag that switches functionallity and verbose of submit button

  // variables holding a user's input
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();

  // instance of FirebaseAuth used to sign in
  final firebaseAuth = FirebaseAuth.instance;

  Widget _title() {
    return const Text('This is the title');
  }

  Widget _entryField(String title, TextEditingController controller) {
    // where the user actually types in the data
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    // error message under the entry field, if it exists
    return Text((errorMsg == "") ? "" : errorMsg);
  }

  Widget _loginOrregisterButton() {
    return TextButton(
      onPressed: () => setState(() {
        isLogin = !isLogin;
      }),
      child: Text(isLogin ? 'register instead' : 'login instead'),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? () async {
                try {
                  await firebaseAuth.signInWithEmailAndPassword(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text);
                } on FirebaseAuthException catch (error) {
                  setState(() {
                    errorMsg = error.message!;
                  });
                }
              }
            : () async {
                try {
                  await firebaseAuth.createUserWithEmailAndPassword(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text);
                } on FirebaseAuthException catch (error) {
                  setState(() {
                    errorMsg = error.message!;
                  });
                }
                await createUser(_controllerUserName.text,
                    _controllerPassword.text, _controllerEmail.text);
              },
        child: Text(isLogin ? 'Login' : 'Register'));
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
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

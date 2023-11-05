import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // variables to store user input
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerUserName = TextEditingController();

  // output error messages (if any)
  String errorMsg = "";

  // instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // flag that determines verbose/functionality
  bool isLogin = true;

  // reusable entry field where user types in information
  Widget _entryField(String? labelText, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
    );
  }

  // contains the list of entryfields needed to sign in/register
  Widget _userForm() {
    return Column(
      children: [
        Text(isLogin ? "Welcome Back!\n\n" : "Create an Account\n\n",
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Spartan')),
        if (isLogin == false) _entryField('User Name\n', _controllerUserName),
        _entryField('Email\n', _controllerEmail),
        // const Text("\n", textAlign: TextAlign.left),
        _entryField('Password\n', _controllerPassword),
      ],
    );
  }

  // contains the list of buttons with their functionality
  Widget _bottomAppBar(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 150),
        ElevatedButton(
            onPressed: () async {
              // to sign in a user
              if (isLogin) {
                if (_controllerEmail.text.isNotEmpty &&
                    _controllerPassword.text.isNotEmpty) {
                  await _auth.signInWithEmailAndPassword(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text);
                }
              }
              // to create a new user
              else {
                if (_controllerEmail.text.isNotEmpty &&
                    _controllerPassword.text.isNotEmpty &&
                    _controllerUserName.text.isNotEmpty) {
                  await _auth.createUserWithEmailAndPassword(
                      email: _controllerEmail.text,
                      password: _controllerPassword.text);
                  await createUser(_controllerUserName.text,
                      _controllerPassword.text, _controllerEmail.text);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(240, 50),
              backgroundColor: const Color.fromARGB(255, 117, 161, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(isLogin ? "Log In" : "Sign Up")),
        const SizedBox(height: 20),
        Text(
            isLogin
                ? "\nDon't have an account?\n"
                : "\nAlready have an account?\n",
            style: const TextStyle(fontSize: 15, fontFamily: 'Spartan'),
            textAlign: TextAlign.center),
        InkWell(
          child: Text(isLogin ? 'Sign Up' : 'Log In',
              style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Spartan')),
          onTap: () {
            setState(() {
              // changing flag value from signing
              //functionality to registering a new user
              isLogin = !isLogin;
            });
          },
        ),
      ],
    );
  }

  // the 'main' of flutter, all widgets here will actually show on screen
  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    //button();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 117, 161, 15),
        body: SingleChildScrollView(
            child: Stack(children: [
          const Column(children: [
            SizedBox(height: 60, width: 410),
            Image(
                image: AssetImage('icons/Title.png'),
                alignment: Alignment.topCenter)
          ]),
          Container(
              padding: const EdgeInsets.all(40),
              margin: const EdgeInsets.only(top: 150),
              width: 415,
              height: 900,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 250, 241, 213),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0)),
              ),
              child: Stack(children: [
                Column(children: [
                  _userForm(),
                  _bottomAppBar(context),
                ])
              ])),
        ])));
  }
}

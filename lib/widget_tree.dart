import 'package:bookmates_app/auth.dart';
import 'package:bookmates_app/home_page.dart'; //importing the hompage
import 'package:bookmates_app/login_register.dart';
import 'package:flutter/material.dart';

// the main hub that determines wether to return the login/register or the homepage

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth()
            .authStateChanges, // the stream of data is from the state changes, with no user signed its null, but with a user signed in, theres some data
        builder: (context, snapshot) {
          // the snapshot represents the data of that one user that signed in
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage(); //if there is no user connected, go straight to the login page
          }
        });
  }
}

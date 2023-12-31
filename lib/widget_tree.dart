import 'package:bookmates_app/Group%20Operations/group_list.dart';
import 'package:bookmates_app/auth.dart';
import 'package:bookmates_app/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// service widget that determines wether to return the login/register or the homepage

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  User? get currentUser => FirebaseAuth.instance.currentUser;
  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Groups();
          } else {
            return const LoginPage();
          }
        });
  }
}

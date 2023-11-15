import 'dart:io';

import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
// the desc text describing user's elements in the profile page
  Widget _userDesc(String userField, userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          userField,
          style: const TextStyle(fontFamily: 'LeagueSpartan'),
        ),
        Text(
          userData,
          style: const TextStyle(fontFamily: 'LeagueSpartan'),
        )
      ],
    );
  }

// sign out button
  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        sleep(const Duration(milliseconds: 200));
        // Restart.restartApp();
        // Navigator.of(context).popAndPushNamed('/homePage');
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'Sign Out',
        style: TextStyle(fontFamily: 'League Spartan'),
      ),
    );
  }

// the bottom buttons of the page
  Widget _bottomButton() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'ID',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
      ],
    );
  }

// the top part of the page, where user can upload a profile pic and display userName
  Widget _userHeading(String userName, imgURL) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imgURL),
          radius: 50,
          backgroundColor: Colors.grey,
        ),
        ElevatedButton(
          onPressed: () async {
            await uploadProfPic();
            setState(() {});
          },
          child: const Text("Upload picture"),
        ),
            // onPressed: uploadProfPic, child: Text('Add profPic')),
        const SizedBox(height: 10), // For spacing
        Text(
          userName,
          style: const TextStyle(fontSize: 24, fontFamily: 'LeagueSpartan'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF75A10F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF75A10F),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontFamily: 'LeagueSpartan'),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _userHeading(
                      snapshot.data!['userName'], snapshot.data!['profPicURL']),
                  const SizedBox(height: 20), // For spacing
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        _userDesc('Email', snapshot.data!['Email']),
                        _userDesc('Password', snapshot.data!['Password']),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // For spacing
                  _signOutButton(),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      bottomNavigationBar: _bottomButton(),
      // You can manage the state of BottomNavigationBar as needed
    );
  }
}

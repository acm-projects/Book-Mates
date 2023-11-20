import 'dart:io';

import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _userDesc(String userPassword, String userEmail) {
    return Container(
      height: 350,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _userDetail('Email', 'Pasword'),
          const SizedBox(
              width: 20), // Adjust for spacing between email and password
          _userDetail(userEmail, userPassword),
          // TODO: add how many groups a user is in
        ],
      ),
    );
  }

  Widget _userDetail(String userField, String userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          userField,
          style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 25,
              color: Color.fromARGB(255, 159, 199, 65),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4), // Adjust for spacing
        Text(
          userData,
          style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 25,
              color: Color.fromARGB(255, 159, 199, 65),
              fontWeight: FontWeight.bold),
        ),
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
        style: TextStyle(
            fontFamily: 'LeagueSpartan',
            fontSize: 20,
            color: Color.fromARGB(255, 159, 199, 65),
            fontWeight: FontWeight.bold),
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
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
          ),
          child: const Text(
            "Add pic",
            style: TextStyle(color: Color(0xFF75A10F)),
          ),
        ),
        // onPressed: uploadProfPic, child: Text('Add profPic')),
        const SizedBox(height: 10), // For spacing
        Text(
          userName,
          style: const TextStyle(
              fontSize: 24,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 159, 199, 65),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 159, 199, 65),
        elevation: 0,
        title: const Text(
          'Your Profile',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold),
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
                        _userDesc(snapshot.data!['Password'],
                            snapshot.data!['Email']),
                        // _userDesc('Password', snapshot.data!['Password']),
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
    );
  }
}

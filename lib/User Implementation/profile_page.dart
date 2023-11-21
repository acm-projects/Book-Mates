// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:bookmates_app/User%20Implementation/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final email = FirebaseAuth.instance.currentUser?.email;

  Widget _userStats(String countType) {
    return FutureBuilder(
      future: getCountSub(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 100,
            width: 175,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 204, 238, 124),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Text(
              (countType == "Groups")
                  ? "Groups: \n         ${snapshot.data![0]}"
                  : "Books: \n          ${snapshot.data![1]}",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          );
        } else
          return const CircularProgressIndicator();
      },
    );
  }

  Widget _userDesc(String userPassword, String userEmail) {
    return FutureBuilder(
      future: getSubcollectionCount('users/$email/Groups'),
      builder: (context, snapshot) {
        return Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 199, 231, 125),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _userDetail('Email', 'Pasword', false),
                  const SizedBox(
                      width:
                          20), // Adjust for spacing between email and password
                  _userDetail(userEmail, userPassword, true),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _userDetail(String userField, String userData, bool hidden) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          userField,
          style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4), // Adjust for spacing
        Text(
          hidden ? '               ******' : userData,
          style: const TextStyle(
              fontFamily: 'LeagueSpartan',
              fontSize: 25,
              color: Colors.black,
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
        // sleep(const Duration(milliseconds: 200));

        // Restart.restartApp();
        Navigator.of(context).popAndPushNamed('/loginPage');
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
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
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
              fontSize: 40,
              fontFamily: 'LeagueSpartan',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 140, 192, 18),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 140, 192, 18),
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
                    _userHeading(snapshot.data!['userName'],
                        snapshot.data!['profPicURL']),
                    const SizedBox(height: 20), // For spacing

                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        _userStats("Groups"),
                        const SizedBox(
                          width: 35,
                        ),
                        _userStats("Books"),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
                    const SizedBox(height: 70), // For spacing
                    _signOutButton(),
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
